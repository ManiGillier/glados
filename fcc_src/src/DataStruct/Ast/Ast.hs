{-
-- EPITECH PROJECT, 2025
-- Glados
-- File description:
-- Ast
-}

module DataStruct.Ast.Ast (Ast (..)
                          , FunctionName
                          , UnaryOperator (..)
                          , BinaryOperator (..)
                          , Operation (..)
                          , Computable (..)
                          , Condition (..)
                          , FunctionBody (..)
                          , FunctionDef (..)
                          , MainFunctionDef (..)
                          , a) where

import qualified DataStruct.Ast.Variable as Var (VariableValue (..)
                                                , VariableName
                               , VariableDef (..), ReturnType (..))
import DataStruct.Lexing (Lexer(Symbol))

type FunctionName = String

data UnaryOperator = BinaryNot | BooleanNot | Negate

data BinaryOperator =
  BinaryAnd | BinaryOr | BooleanAnd | BooleanOr
  | Xor | BitShiftLeft | BitShiftRight
  | Add | Sub | Multiplication | Division | Modulo
  | Superior | SuperiorOrEq | Inferior | InferiorOrEq
  | Equals | Is | Different

data Operation =
  BinaryOperation BinaryOperator Computable Computable
  | UnaryOperation UnaryOperator Computable

data Computable =
  Value Var.VariableValue
  | Operation Operation
  | Variable Var.VariableName

-- 1 + 1 - 5
a :: Computable
a = Operation $ BinaryOperation Sub
  (Operation $ BinaryOperation Add (Value (Var.Int 1)) (Value (Var.Int 1)))
  (Value $ Var.Int 5)

data Condition = Condition Computable

data FunctionBody =
  Assign Var.VariableName Computable
  | If Condition FunctionBody (Maybe FunctionBody)
  | Invoke FunctionName [Computable]
  | Loop Condition FunctionBody
  | Return Computable
  | Show Computable

data FunctionDef = Function FunctionName Var.ReturnType [Var.VariableDef] FunctionBody

data MainFunctionDef = Main [Var.VariableDef] FunctionBody

data Ast = Ast MainFunctionDef [FunctionDef]
