{-
-- EPITECH PROJECT, 2025
-- fcc_src [WSL: Ubuntu-24.04]
-- File description:
-- Parser
-}

module Parser.Parser(takeUntil, findMain, getMainCount, parseMain,
  parseVariableDefinitions) where
import DataStruct.Lexing as L (LexedData(..), FuncTypes(..), VarValue(..), LexedTypes (LInt, LBoolean, LString), Operations (..))
import Error.MaybeError (MaybeError(Error, Correct))
import DataStruct.Ast.Ast as Ast (MainFunctionDef(..), FunctionBody, Condition(..), Computable (Value), FunctionBodyContent (If), BinaryOperator (..), Computable(..), Operation (..))
import qualified DataStruct.Ast.Type as Type
import qualified DataStruct.Ast.Variable as Var
import Error.ErrorList (noMainErr, multipleMainErr)
import Debug.Trace (trace, traceShowId)

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
    (L.Int x)) = Var.VariableDef name Type.Int (Var.Int x)
parseVariableDefinition (VariableDeclaration name LBoolean
  (L.Bool x)) = Var.VariableDef name Type.Bool (Var.Bool x)
parseVariableDefinition (VariableDeclaration name LString
  (L.String x)) = Var.VariableDef name Type.String
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
parseComputable l = traceShowId computable
  where (computable,_) = rpnToAst $ infixToRPN l

precedence :: Operations -> Int
precedence L.Add = 9
precedence Multiply = 10
precedence Subtract = 9
precedence Divide = 10
precedence L.Modulo = 10
precedence L.Equal = 6
precedence L.Different = 6
precedence L.BinaryAnd = 5
precedence L.BinaryOr = 3
precedence L.And = 2
precedence L.Or = 1
precedence L.Xor = 4
precedence LeftBitshift = 8
precedence RightBitshift = 8
precedence L.Inferior = 7
precedence L.Superior = 7
precedence InferiorOrEqual = 7
precedence SuperiorOrEqual = 7

precedenceGorEq :: Operations -> Operations -> Bool
precedenceGorEq a b = precedence a >= precedence b

-- Operator -> Stack -> Output
shuntingYardOperator :: Operations -> [LexedData] -> ([LexedData],[LexedData])
shuntingYardOperator op1 s@(L.Operation op2:sr)
  | precedenceGorEq op2 op1 = (s', L.Operation op2 : o')
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
    where (s',o') = shuntingYardOperator op1 s
shuntingYardAlgorithm (L.Operation op1:xs) s
  = shuntingYardAlgorithm xs (L.Operation op1:s)
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

rpnToAst :: [LexedData] -> (Computable,[LexedData])
rpnToAst (L.Number x:xs) = (Ast.Value $ Var.Int x,xs)
rpnToAst (L.Operation op:xs) =
  (Ast.Operation $ Ast.BinaryOperation (lOpToAstOp op) a b , as)
  where (b,bs) = rpnToAst xs
        (a,as) = rpnToAst bs

parseFunctionBody :: [LexedData] -> FunctionBody
parseFunctionBody (WithVariables : xs) = parseFunctionBody xs
parseFunctionBody ((VariableDeclaration _ _ _) : xs) = parseFunctionBody xs
parseFunctionBody (WithParameters : xs) = parseFunctionBody xs
parseFunctionBody (EndFunction : _) = []
parseFunctionBody (L.If : xs) = Ast.If
    (parseCondition (takeUntil xs Then)) [] Nothing : parseFunctionBody xs
parseFunctionBody (_:xs) = parseFunctionBody xs
parseFunctionBody [] = []
-- parseFunctionBody (Display : Text "") = 
-- parseFunctionBody (x : xs) = parseInstruction x : parseFunctionBody xs

parseMain' :: [LexedData] -> MainFunctionDef
parseMain' xs = Ast.Main
  (parseVariableDefinitions xs) (parseFunctionBody xs)

parseMain :: [LexedData] -> MaybeError MainFunctionDef
parseMain xs
    | count == 1 = Correct (parseMain' (findMain xs))
    | count == 0 = Error noMainErr ""
    | otherwise = Error multipleMainErr ""
    where
      count = getMainCount xs
