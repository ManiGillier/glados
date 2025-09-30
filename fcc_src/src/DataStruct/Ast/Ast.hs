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
                          , MainFunctionDef (..)) where

import DataStruct.Ast.Variable (VariableValue (..), VariableName
                               , VariableDef (..), ReturnType (..))

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

-- a :: Computable
-- a = Operation $ BinaryOperation (Sub (Operation $ BinaryOperation (Add (Value $ Int 2) (Value $ Int 3))) (Value $ Int 5))

data Computable =
  Value VariableValue
  | Operation Operation
  | Variable VariableName

data Condition = Condition Computable

data FunctionBody =
  Assign VariableName Computable
  | If Condition FunctionBody (Maybe FunctionBody)
  | Invoke FunctionName [Computable]
  | Loop Condition FunctionBody
  | Return Computable
  | Show Computable

data FunctionDef = Function FunctionName ReturnType [VariableDef] FunctionBody

data MainFunctionDef = Main [VariableDef] FunctionBody

data Ast = Ast MainFunctionDef [FunctionDef]
