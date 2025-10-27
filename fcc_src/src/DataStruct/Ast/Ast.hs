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
                          , FunctionBody
                          , FunctionBodyContent (..)
                          , FunctionDef (..)
                          , MainFunctionDef (..)
                          , CombinedAst (..)
                          , IsReturning
                          ) where

import qualified DataStruct.Ast.Variable as Var ( VariableName
                                                , VariableDef (..)
                                                , FuncParam
                                                )
import Data.Int (Int64)

type FunctionName = String

data UnaryOperator = BinaryNot | BooleanNot | Negate
  deriving (Eq, Show)

data BinaryOperator =
  BinaryAnd | BinaryOr | BooleanAnd | BooleanOr
  | Xor | BitShiftLeft | BitShiftRight
  | Add | Sub | Multiplication | Division | Modulo
  | Superior | SuperiorOrEq | Inferior | InferiorOrEq
  | Equals | Different
  deriving (Eq, Show)

data Operation =
  BinaryOperation BinaryOperator Computable Computable
  | UnaryOperation UnaryOperator Computable
  deriving (Eq, Show)

data Computable =
  Value Int64
  | Operation Operation
  | Variable Var.VariableName
  deriving (Eq, Show)

data Condition = Condition Computable
  deriving (Eq, Show)

data FunctionBodyContent =
  Assign Var.VariableName Computable
  | If Condition FunctionBody (Maybe FunctionBody)
  | Invoke FunctionName [Computable] (Maybe Var.VariableName)
  | Loop Condition FunctionBody
  | Return Computable
  | Show Computable
  | ShowStr String
  deriving (Eq, Show)

type FunctionBody = [FunctionBodyContent]

type IsReturning = Bool

data FunctionDef = Function FunctionName IsReturning
  [Var.FuncParam] [Var.VariableDef] FunctionBody
  deriving (Eq, Show)

data MainFunctionDef = Main [Var.VariableDef] FunctionBody
  deriving (Eq, Show)

data Ast = Ast (Maybe MainFunctionDef) [FunctionDef] deriving (Eq, Show)

data CombinedAst = CAst MainFunctionDef [FunctionDef] deriving (Eq, Show)
