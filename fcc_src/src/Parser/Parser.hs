{-
-- EPITECH PROJECT, 2025
-- fcc_src [WSL: Ubuntu-24.04]
-- File description:
-- Parser
-}

module Parser.Parser(takeUntil, findMain, getMainCount, parseMain,
  parseVariableDefinitions) where
import DataStruct.Lexing (LexedData(..), FuncTypes(..), VarValue(..), LexedTypes (LInt, LBoolean, LString))
import Error.MaybeError (MaybeError(Error, Correct))
import DataStruct.Ast.Ast(MainFunctionDef(..), FunctionBody, Condition(..), Computable (Value), FunctionBodyContent (If))
import qualified DataStruct.Ast.Type as Type
import qualified DataStruct.Ast.Variable as Var
import Error.ErrorList (noMainErr, multipleMainErr)

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

parseCondition :: [LexedData] -> Condition
parseCondition = Condition . parseComputable

parseComputable :: [LexedData] -> Computable
parseComputable _ = Value $ Var.Bool True

parseFunctionBody :: [LexedData] -> FunctionBody
parseFunctionBody (WithVariables : xs) = parseFunctionBody xs
parseFunctionBody ((VariableDeclaration _ _ _) : xs) = parseFunctionBody xs
parseFunctionBody (WithParameters : xs) = parseFunctionBody xs
parseFunctionBody (EndFunction : _) = []
parseFunctionBody (DataStruct.Lexing.If : xs) = DataStruct.Ast.Ast.If
    (parseCondition (takeUntil xs Then)) [] Nothing : parseFunctionBody xs
parseFunctionBody (_:xs) = parseFunctionBody xs
parseFunctionBody [] = []
-- parseFunctionBody (Display : Text "") = 
-- parseFunctionBody (x : xs) = parseInstruction x : parseFunctionBody xs

parseMain' :: [LexedData] -> MainFunctionDef
parseMain' xs = DataStruct.Ast.Ast.Main
  (parseVariableDefinitions xs) (parseFunctionBody xs)

parseMain :: [LexedData] -> MaybeError MainFunctionDef
parseMain xs
    | count == 1 = Correct (parseMain' (findMain xs))
    | count == 0 = Error noMainErr ""
    | otherwise = Error multipleMainErr ""
    where
      count = getMainCount xs
