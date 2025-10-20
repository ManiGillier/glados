{-
-- EPITECH PROJECT, 2025
-- fcc_src [WSL: Ubuntu-24.04]
-- File description:
-- Parser
-}

module Parser.Parser(takeUntil, findMain, getMainCount, parseMain,
  parseVariableDefinitions, skipTo,
  extractBodyFunctionFromNextIf,
  extractBodyFunctionFromNextElse,
  parseFunctions, buildAst) where
import DataStruct.Lexing (LexedData(..), FuncTypes(..), VarValue(..), LexedTypes (LInt, LBoolean, LString, LVoid))
import DataStruct.Ast.Ast(MainFunctionDef(..), FunctionBody, Condition(..), Computable (Value), FunctionBodyContent (If, Show, Assign, Return, Loop, Invoke), FunctionDef (Function), Ast (Ast))
import qualified DataStruct.Ast.Type as Type
import qualified DataStruct.Ast.Variable as Var
import DataStruct.Ast.Variable (FuncParam(FuncParam))

takeUntil :: [LexedData] -> LexedData -> [LexedData]
takeUntil [] _ = []
takeUntil (x:xs) stop
    | x == stop = []
    | stop `elem` (x:xs) = x : takeUntil xs stop
    | otherwise = []

getMainCount :: [LexedData] -> Int
getMainCount [] = 0
getMainCount (FuncType DataStruct.Lexing.Main : xs) = 1 + getMainCount xs
getMainCount (_ : xs) = getMainCount xs

findMain :: [LexedData] -> [LexedData]
findMain (FuncDef:FuncType DataStruct.Lexing.Main:xs) =
  takeUntil xs EndFunction
findMain (_:xs) = findMain xs
findMain [] = []

-- TODO: Remove this error (?)
parseVariableDefinition :: LexedData -> Var.VariableDef
parseVariableDefinition (VariableDeclaration name LInt
    (DataStruct.Lexing.Int x)) = Var.VariableDef name Type.Int (Var.Int x)
parseVariableDefinition (VariableDeclaration name LBoolean
  (DataStruct.Lexing.Bool x)) = Var.VariableDef name Type.Bool (Var.Bool x)
parseVariableDefinition (VariableDeclaration name LString
  (DataStruct.Lexing.String x)) = Var.VariableDef name Type.String
    (Var.String x)
parseVariableDefinition _ = error "Could not find type."

parseVariableDefinitions :: [LexedData] -> [Var.VariableDef]
parseVariableDefinitions (WithVariables : xs) = parseVariableDefinitions xs
parseVariableDefinitions (x@(VariableDeclaration _ _ _) : xs) =
  parseVariableDefinition x : parseVariableDefinitions xs
parseVariableDefinitions (_ : xs) = parseVariableDefinitions xs
parseVariableDefinitions [] = []

parseCondition :: [LexedData] ->  Condition
parseCondition _ = Condition (Value (Var.Bool True))

extractConditionFromNextIf :: [LexedData] -> [LexedData]
extractConditionFromNextIf (DataStruct.Lexing.If : xs) = takeUntil xs Then
extractConditionFromNextIf (_ : xs) = extractConditionFromNextIf xs
extractConditionFromNextIf [] = []

extractConditionFromNextWhile :: [LexedData] -> [LexedData]
extractConditionFromNextWhile (DataStruct.Lexing.While : xs) =
    takeUntil xs Then
extractConditionFromNextWhile (_ : xs) = extractConditionFromNextWhile xs
extractConditionFromNextWhile [] = []

extractBodyFunctionFromNextWhile :: [LexedData] -> [LexedData]
extractBodyFunctionFromNextWhile (DataStruct.Lexing.Then : xs) =
    takeUntil xs EndWhile
extractBodyFunctionFromNextWhile (_ : xs) = extractBodyFunctionFromNextWhile xs
extractBodyFunctionFromNextWhile [] = []

extractBodyFunctionFromNextIf :: [LexedData] -> [LexedData]
extractBodyFunctionFromNextIf (DataStruct.Lexing.Then : xs) =
    takeUntil xs EndIf
extractBodyFunctionFromNextIf (_ : xs) = extractBodyFunctionFromNextIf xs
extractBodyFunctionFromNextIf [] = []

extractBodyFunctionFromNextElse :: [LexedData] -> [LexedData]
extractBodyFunctionFromNextElse (DataStruct.Lexing.Else : xs) =
    takeUntil xs EndIf
extractBodyFunctionFromNextElse (_ : xs) = extractBodyFunctionFromNextElse xs
extractBodyFunctionFromNextElse [] = []

extractBodyFunctionFromNextIfWithElse :: [LexedData] -> [LexedData]
extractBodyFunctionFromNextIfWithElse (DataStruct.Lexing.Then : xs) =
    takeUntil xs Else
extractBodyFunctionFromNextIfWithElse (_ : xs) =
    extractBodyFunctionFromNextIf xs
extractBodyFunctionFromNextIfWithElse [] = []

skipTo :: LexedData -> [LexedData] -> [LexedData]
skipTo _ [] = []
skipTo t (x:xs)
    | t == x = xs
    | otherwise = skipTo t xs

getAllComputables :: [LexedData] -> [LexedData]
getAllComputables (x@(Number _):xs) = x : getAllComputables xs
getAllComputables (x@(Symbol _):xs) = x : getAllComputables xs
getAllComputables (x@(UnaryOperation _) : xs) = x : getAllComputables xs
getAllComputables (x@(Operation _) : xs) = x :getAllComputables xs
getAllComputables _ = []

parseComputable :: [LexedData] -> Computable
parseComputable _ = Value (Var.Bool True)

parseDisplay :: [LexedData] -> FunctionBodyContent
parseDisplay xs = DataStruct.Ast.Ast.Show (parseComputable xs)

parseAssign :: String -> [LexedData] -> FunctionBodyContent
parseAssign varName computables = DataStruct.Ast.Ast.Assign varName
    (parseComputable computables)

parseWhile :: [LexedData] -> [LexedData] -> FunctionBodyContent
parseWhile condition body = DataStruct.Ast.Ast.Loop
    (Condition (parseComputable condition)) (parseFunctionBody body)

parseReturn :: [LexedData] -> FunctionBodyContent
parseReturn xs = DataStruct.Ast.Ast.Return (parseComputable xs)

isThereElse :: [LexedData] -> Bool
isThereElse (EndIf:_) = False
isThereElse [] = False
isThereElse (Else:_) = True
isThereElse (_:xs) = isThereElse xs

skipComputables :: [LexedData] -> [LexedData]
skipComputables ((Number _):xs) = skipComputables xs
skipComputables ((Symbol _):xs) = skipComputables xs
skipComputables ((UnaryOperation _) : xs) = skipComputables xs
skipComputables ((Operation _) : xs) = skipComputables xs
skipComputables xs = xs

parseInvokeParams :: [LexedData] -> [Computable]
parseInvokeParams (WithParameters : xs) = parseInvokeParams xs
parseInvokeParams (InvokeParameter c : xs) = parseComputable c :
    parseInvokeParams xs
parseInvokeParams _ = []

parseInvoke :: String -> Maybe String -> [LexedData] -> FunctionBodyContent
parseInvoke name l x = DataStruct.Ast.Ast.Invoke name (parseInvokeParams x) l

parseFunctionBody :: [LexedData] -> FunctionBody
parseFunctionBody (DataStruct.Lexing.If : xs)
    | isThereElse xs = DataStruct.Ast.Ast.If
    (parseCondition (extractConditionFromNextIf xs))
    (parseFunctionBody (extractBodyFunctionFromNextIfWithElse xs))
    (Just (parseFunctionBody (extractBodyFunctionFromNextElse xs))) :
    parseFunctionBody (skipTo EndIf xs)
    | otherwise = DataStruct.Ast.Ast.If
    (parseCondition (extractConditionFromNextIf xs))
    (parseFunctionBody (extractBodyFunctionFromNextIf xs)) Nothing :
    parseFunctionBody (skipTo EndIf xs)
parseFunctionBody (Display:Text _:xs) = parseFunctionBody xs -- Not implemented
parseFunctionBody (Display:xs) = parseDisplay (getAllComputables xs)
    : parseFunctionBody (skipComputables xs)
parseFunctionBody (DataStruct.Lexing.Assign:Symbol s:xs) =
    parseAssign s (getAllComputables xs) :
    parseFunctionBody (skipComputables xs)
parseFunctionBody (DataStruct.Lexing.Returns:xs) =
    parseReturn (getAllComputables xs) :
    parseFunctionBody (skipComputables xs)
parseFunctionBody (DataStruct.Lexing.While:xs) =
    parseWhile (extractConditionFromNextWhile xs)
    (extractBodyFunctionFromNextWhile xs) :
    parseFunctionBody (skipTo EndWhile xs)
parseFunctionBody (DataStruct.Lexing.Invoke :
    Symbol name : AssignResultTo : Symbol x : xs) =
        parseInvoke name (Just x) xs :
        parseFunctionBody xs
parseFunctionBody (DataStruct.Lexing.Invoke :
    Symbol name : xs) =
        parseInvoke name Nothing xs :
        parseFunctionBody xs
parseFunctionBody (_:xs) = parseFunctionBody xs
parseFunctionBody [] = []

parseMain' :: [LexedData] -> MainFunctionDef
parseMain' xs = DataStruct.Ast.Ast.Main
  (parseVariableDefinitions xs) (parseFunctionBody xs)

parseMain :: [LexedData] -> Maybe MainFunctionDef
parseMain xs
    | count == 1 = Just (parseMain' (findMain xs))
    | count == 0 = Nothing
    | otherwise = Nothing
    where
      count = getMainCount xs

convertReturnType :: LexedTypes -> Var.ReturnType
convertReturnType LBoolean = Var.Value Type.Bool
convertReturnType LInt = Var.Value Type.Int
convertReturnType LString = Var.Value Type.String
convertReturnType LVoid = Var.Void

-- TODO: Change the '_' :sob:
convertVariableType :: LexedTypes -> Type.VariableType
convertVariableType LBoolean = Type.Bool
convertVariableType LInt = Type.Int
convertVariableType _ = Type.String

parseParam :: String -> LexedTypes -> Var.FuncParam
parseParam x t = FuncParam x (convertVariableType t)

parseParams :: [LexedData] -> [Var.FuncParam]
parseParams (WithParameters : xs) = parseParams xs
parseParams (Parameter s t : xs) = parseParam s t : parseParams xs
parseParams _ = []

parseFunction :: String -> LexedTypes -> [LexedData] -> FunctionDef
parseFunction name t xs = DataStruct.Ast.Ast.Function name
    (convertReturnType t) (parseParams (skipTo WithParameters xs))
    (parseVariableDefinitions xs)
    (parseFunctionBody xs)

parseFunctions :: [LexedData] -> [FunctionDef]
parseFunctions (FuncDef : FuncType DataStruct.Lexing.Function : Symbol s :
    ReturnType : LexedType t : xs) =
    parseFunction s t (takeUntil xs EndFunction) :
    parseFunctions (skipTo EndIf xs)
parseFunctions (_:xs) = parseFunctions xs
parseFunctions [] = []

buildAst :: [LexedData] -> Ast
buildAst xs = Ast (parseMain xs) (parseFunctions xs)
