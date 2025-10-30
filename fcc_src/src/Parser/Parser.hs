{-
-- EPITECH PROJECT, 2025
-- fcc_src [WSL: Ubuntu-24.04]
-- File description:
-- Parser
-}

module Parser.Parser
  ( takeUntil, findMain, getMainCount, parseMain,
    parseVariableDefinitions, skipTo,
    extractBodyFunctionFromNextIf,
    extractBodyFunctionFromNextElse,
    parseFunctions, buildAst,
    parseComputable, extractConditionFromNextWhile,
    extractBodyFunctionFromNextWhile,
    getAllComputables,
    parseDisplay,
    parseAssign,
    parseWhile, isThereElse, parseReturn, skipComputables,
    parseInvokeParams,
    parseInvoke,
    escapedCharacter, transformString, convertReturnType, parseParams,
    parseFunctionBody
  , precedence
  , lOpToAstOp
  , unaryLOpToAstOp
  , rpnToAst
                    ) where

import DataStruct.Lexing (LexedData(..), FuncTypes(..), LexedTypes (LInt, LBoolean, LVoid))
import DataStruct.Ast.Ast(MainFunctionDef(..), FunctionBody, Condition(..), FunctionBodyContent (If, Show, Assign, Return, Loop, Invoke), FunctionDef (Function), Ast (Ast))
import DataStruct.Lexing as L (LexedData(..), FuncTypes(..), VarValue(..), Operations (..), UnaryOperations (..))
import Error.MaybeError (MaybeError(Error, Correct))
import DataStruct.Ast.Ast as Ast (MainFunctionDef(..), BinaryOperator (..), Computable(..), Operation (..), UnaryOperator (..), IsReturning, FunctionBodyContent (ShowStr))
import qualified DataStruct.Ast.Variable as Var
import DataStruct.Ast.Variable (FuncParam(FuncParam))
import Error.ErrorList (alreadyDefFuncErr)

takeUntil :: [LexedData] -> LexedData -> [LexedData]
takeUntil [] _ = []
takeUntil (x:xs) stop
    | x == stop = []
    | stop `elem` (x:xs) = x : takeUntil xs stop
    | otherwise = []

getMainCount :: [LexedData] -> Int
getMainCount [] = 0
getMainCount (FuncType L.Main : xs) = 1 + getMainCount xs
getMainCount (_ : xs) = getMainCount xs

findMain :: [LexedData] -> [LexedData]
findMain (FuncDef:FuncType L.Main:xs) =
  takeUntil xs EndFunction
findMain (_:xs) = findMain xs
findMain [] = []

-- TODO: Remove this error (?)
parseVariableDefinition :: LexedData -> Var.VariableDef
parseVariableDefinition (VariableDeclaration name LInt
    (L.Int x)) = Var.VariableDef name x
parseVariableDefinition (VariableDeclaration name LBoolean (L.Int x)) =
    Var.VariableDef name x
parseVariableDefinition t = error $ "Could not find type: " ++ show t ++ "."

parseVariableDefinitions :: [LexedData] -> [Var.VariableDef]
parseVariableDefinitions (WithVariables : xs) = parseVariableDefinitions xs
parseVariableDefinitions (x@(VariableDeclaration _ _ _) : xs) =
  parseVariableDefinition x : parseVariableDefinitions xs
parseVariableDefinitions (_ : xs) = parseVariableDefinitions xs
parseVariableDefinitions [] = []

parseCondition :: [LexedData] -> Condition
parseCondition = Condition . parseComputable

parseComputable :: [LexedData] -> Computable
parseComputable = fst . rpnToAst . infixToRPN

precedence :: LexedData -> Int
precedence (L.Operation L.Add) = 9
precedence (L.Operation Multiply) = 10
precedence (L.Operation Subtract) = 9
precedence (L.Operation Divide) = 10
precedence (L.Operation L.Modulo) = 10
precedence (L.Operation L.Equal) = 6
precedence (L.Operation L.Different) = 6
precedence (L.Operation L.BinaryAnd) = 5
precedence (L.Operation L.BinaryOr) = 3
precedence (L.Operation L.And) = 2
precedence (L.Operation L.Or) = 1
precedence (L.Operation L.Xor) = 4
precedence (L.Operation LeftBitshift) = 8
precedence (L.Operation RightBitshift) = 8
precedence (L.Operation L.Inferior) = 7
precedence (L.Operation L.Superior) = 7
precedence (L.Operation InferiorOrEqual) = 7
precedence (L.Operation SuperiorOrEqual) = 7
precedence (L.UnaryOperation _) = 11
precedence _ = 0

precedenceCmp :: (Int -> Int -> Bool) -> LexedData -> LexedData -> Bool
precedenceCmp f a b = precedence a `f` precedence b

-- Operator -> Stack -> Output
shuntingYardOperator :: LexedData -> [LexedData] -> ([LexedData],[LexedData])
shuntingYardOperator op1@(L.Operation _) s@(L.Operation op2:sr)
  | precedenceCmp (>=) (L.Operation op2) op1 = (s', L.Operation op2 : o')
  | otherwise = (s,[])
        where (s',o') = shuntingYardOperator op1 sr
shuntingYardOperator op1@(L.Operation _) s@(L.UnaryOperation op2:sr)
  | precedenceCmp (>=) (L.UnaryOperation op2) op1
        = (s', L.UnaryOperation op2 : o')
  | otherwise = (s,[])
        where (s',o') = shuntingYardOperator op1 sr
shuntingYardOperator op1@(L.UnaryOperation _) s@(L.Operation op2:sr)
  | precedenceCmp (>) (L.Operation op2) op1 = (s', L.Operation op2 : o')
  | otherwise = (s,[])
        where (s',o') = shuntingYardOperator op1 sr
shuntingYardOperator op1@(L.UnaryOperation _) s@(L.UnaryOperation op2:sr)
  | precedenceCmp (>) (L.UnaryOperation op2) op1
        = (s', L.UnaryOperation op2 : o')
  | otherwise = (s,[])
        where (s',o') = shuntingYardOperator op1 sr
shuntingYardOperator _ s = (s, [])

shuntingYardParenthesis :: [LexedData] -> ([LexedData],[LexedData])
shuntingYardParenthesis [] = ([],[])
shuntingYardParenthesis (OpenParenthesis:s) = (s,[])
shuntingYardParenthesis (x:xs) = (s',x:o)
  where (s',o) = shuntingYardParenthesis xs

-- Input -> Stack -> Output
shuntingYardAlgorithm :: [LexedData] -> [LexedData] -> [LexedData]
shuntingYardAlgorithm [] s = s
shuntingYardAlgorithm (L.Operation op1:xs) s@(L.Operation _:_)
  = o' ++ shuntingYardAlgorithm xs (L.Operation op1 : s')
    where (s',o') = shuntingYardOperator (L.Operation op1) s
shuntingYardAlgorithm (L.Operation op1:xs) s@(L.UnaryOperation _:_)
  = o' ++ shuntingYardAlgorithm xs (L.Operation op1 : s')
    where (s',o') = shuntingYardOperator (L.Operation op1) s
shuntingYardAlgorithm (L.UnaryOperation op1:xs) s@(L.Operation _:_)
  = o' ++ shuntingYardAlgorithm xs (L.UnaryOperation op1 : s')
    where (s',o') = shuntingYardOperator (L.UnaryOperation op1) s
shuntingYardAlgorithm (L.UnaryOperation op1:xs) s@(L.UnaryOperation _:_)
  = o' ++ shuntingYardAlgorithm xs (L.UnaryOperation op1 : s')
    where (s',o') = shuntingYardOperator (L.UnaryOperation op1) s
shuntingYardAlgorithm (L.Operation op1:xs) s
  = shuntingYardAlgorithm xs (L.Operation op1:s)
shuntingYardAlgorithm (L.UnaryOperation op1:xs) s
  = shuntingYardAlgorithm xs (L.UnaryOperation op1:s)
shuntingYardAlgorithm (OpenParenthesis:xs) s
  = shuntingYardAlgorithm xs (OpenParenthesis:s)
shuntingYardAlgorithm (ClosedParenthesis:xs) s
  = o ++ shuntingYardAlgorithm xs s'
        where (s',o) = shuntingYardParenthesis s
shuntingYardAlgorithm (x:xs) s = x : shuntingYardAlgorithm xs s

infixToRPN :: [LexedData] -> [LexedData]
infixToRPN l = reverse $ shuntingYardAlgorithm l []

lOpToAstOp :: L.Operations -> Ast.BinaryOperator
lOpToAstOp L.Add = Ast.Add
lOpToAstOp L.Multiply = Ast.Multiplication
lOpToAstOp L.Subtract = Ast.Sub
lOpToAstOp L.Divide = Ast.Division
lOpToAstOp L.Modulo = Ast.Modulo
lOpToAstOp L.BinaryAnd = Ast.BinaryAnd
lOpToAstOp L.BinaryOr = Ast.BinaryOr
lOpToAstOp L.And = Ast.BooleanAnd
lOpToAstOp L.Or = Ast.BooleanOr
lOpToAstOp L.Xor = Ast.Xor
lOpToAstOp L.LeftBitshift = Ast.BitShiftLeft
lOpToAstOp L.RightBitshift = Ast.BitShiftRight
lOpToAstOp L.Equal = Ast.Equals
lOpToAstOp L.Different = Ast.Different
lOpToAstOp L.Inferior = Ast.Inferior
lOpToAstOp L.Superior = Ast.Superior
lOpToAstOp L.InferiorOrEqual = Ast.InferiorOrEq
lOpToAstOp L.SuperiorOrEqual = Ast.SuperiorOrEq

unaryLOpToAstOp :: L.UnaryOperations -> Ast.UnaryOperator
unaryLOpToAstOp L.Not = Ast.BooleanNot
unaryLOpToAstOp L.BinaryNot = Ast.BinaryNot
unaryLOpToAstOp L.Negate = Ast.Negate

rpnToAst :: [LexedData] -> (Computable,[LexedData])
rpnToAst (L.Number x:xs) = (Ast.Value x,xs)
rpnToAst (L.Operation op:xs) =
  (Ast.Operation $ Ast.BinaryOperation (lOpToAstOp op) a b , as)
  where (b,bs) = rpnToAst xs
        (a,as) = rpnToAst bs
rpnToAst (L.UnaryOperation op:xs) =
  (Ast.Operation $ Ast.UnaryOperation (unaryLOpToAstOp op) a , as)
  where (a,as) = rpnToAst xs
rpnToAst (L.Symbol x:xs) = (Ast.Variable x, xs)
rpnToAst e = error $ "parsing error: " ++ show e


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

skipTo :: LexedData -> [LexedData] -> [LexedData]
skipTo _ [] = []
skipTo t (x:xs)
    | t == x = xs
    | otherwise = skipTo t xs

getAllComputables :: [LexedData] -> [LexedData]
getAllComputables (x@(Number _):xs) = x : getAllComputables xs
getAllComputables (x@(Symbol _):xs) = x : getAllComputables xs
getAllComputables (x@(L.UnaryOperation _) : xs) = x : getAllComputables xs
getAllComputables (x@(L.Operation _) : xs) = x :getAllComputables xs
getAllComputables (x@(L.OpenParenthesis) : xs) = x :getAllComputables xs
getAllComputables (x@(L.ClosedParenthesis) : xs) = x :getAllComputables xs
getAllComputables _ = []

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
skipComputables ((L.UnaryOperation _) : xs) = skipComputables xs
skipComputables ((L.Operation _) : xs) = skipComputables xs
skipComputables ((L.OpenParenthesis) : xs) = skipComputables xs
skipComputables ((L.ClosedParenthesis) : xs) = skipComputables xs
skipComputables xs = xs

parseInvokeParams :: [LexedData] -> [Computable]
parseInvokeParams (WithParameters : xs) = parseInvokeParams xs
parseInvokeParams (InvokeParameter c : xs) = parseComputable c :
    parseInvokeParams xs
parseInvokeParams _ = []

parseInvoke :: String -> Maybe String -> [LexedData] -> FunctionBodyContent
parseInvoke name l x = DataStruct.Ast.Ast.Invoke name (parseInvokeParams x) l

escapedCharacter :: Char -> Char
escapedCharacter 'n' = '\n'
escapedCharacter 't' = '\t'
escapedCharacter '0' = '\0'
escapedCharacter 'r' = '\r'
escapedCharacter 'a' = '\a'
escapedCharacter x  = x

transformString :: String -> String
transformString ('\\':c: xs) = escapedCharacter c : transformString xs
transformString (x:xs) = x : transformString xs
transformString [] = []

parseFunctionBody :: [LexedData] -> FunctionBody
parseFunctionBody (DataStruct.Lexing.If : xs)
    | isThereElse xs = DataStruct.Ast.Ast.If
    (parseCondition (takeUntil xs Then))
    (parseFunctionBody (takeUntil (skipComputables xs) Else))
    (Just (parseFunctionBody (extractBodyFunctionFromNextElse xs))) :
    parseFunctionBody (skipTo EndIf xs)
    | otherwise = DataStruct.Ast.Ast.If
    (parseCondition (takeUntil xs Then))
    (parseFunctionBody (extractBodyFunctionFromNextIf xs)) Nothing :
    parseFunctionBody (skipTo EndIf xs)
parseFunctionBody (Display:Text s:xs) = ShowStr (transformString s) :
    parseFunctionBody xs
parseFunctionBody (Display:xs) = parseDisplay (getAllComputables xs)
    : parseFunctionBody (skipComputables xs)
parseFunctionBody (DisplayNewLine:xs) = Show (Value 10)
    : parseFunctionBody (skipComputables xs)
parseFunctionBody (DataStruct.Lexing.Assign:Symbol s:xs) =
    parseAssign s (getAllComputables xs) :
    parseFunctionBody (skipComputables xs)
parseFunctionBody (DataStruct.Lexing.Return:xs) =
    parseReturn (getAllComputables xs) :
    parseFunctionBody (skipComputables xs)
parseFunctionBody (DataStruct.Lexing.While:xs) =
    parseWhile (takeUntil xs Then)
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
parseFunctionBody (WithVariables : xs) = parseFunctionBody xs
parseFunctionBody ((VariableDeclaration _ _ _) : xs) = parseFunctionBody xs
parseFunctionBody (WithParameters : xs) = parseFunctionBody xs
parseFunctionBody (EndFunction : _) = []
parseFunctionBody (_:xs) = parseFunctionBody xs
parseFunctionBody [] = []

parseMain' :: [LexedData] -> MainFunctionDef
parseMain' xs = Ast.Main
  (parseVariableDefinitions xs) (parseFunctionBody xs)

parseMain :: [LexedData] -> Maybe MainFunctionDef
parseMain xs
    | count == 1 = Just (parseMain' (findMain xs))
    | otherwise = Nothing
    where
      count = getMainCount xs


convertReturnType :: LexedTypes -> IsReturning
convertReturnType LBoolean = True
convertReturnType LInt = True
convertReturnType LVoid = False

-- TODO: Change the '_' :sob:
{-
convertVariableType :: LexedTypes -> Type.VariableType
convertVariableType LBoolean = Type.Bool
convertVariableType LInt = Type.Int
convertVariableType _ = Type.String
-}

parseParam :: String -> LexedTypes -> Var.FuncParam
parseParam x _ = FuncParam x

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

buildAst :: [LexedData] -> MaybeError Ast
buildAst xs
    | count > 1 = Error alreadyDefFuncErr "main"
    | otherwise = Correct (Ast (parseMain xs) (parseFunctions xs))
    where count = getMainCount xs
