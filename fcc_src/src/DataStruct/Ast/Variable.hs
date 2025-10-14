{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- ast variable
-}

module DataStruct.Ast.Variable (VariableValue (..), VariableName
                               , VariableDef (..)
                               , ReturnType (..)
                               , FuncParam (..)
                               ) where

import DataStruct.Ast.Type (VariableType (..))
import Data.Int (Int64)

data VariableValue =
  Bool Bool
  | String String
  | Int Int64
  deriving (Show, Eq)

type VariableName = String

data VariableDef = VariableDef VariableName VariableType VariableValue
  deriving (Eq, Show)

data ReturnType = Void | Value VariableType
  deriving (Eq, Show)

data FuncParam = FuncParam VariableName VariableType
  deriving (Eq, Show)
