{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- ast variable
-}

module DataStruct.Ast.Variable (VariableValue (..), VariableName
                               , VariableDef (..)
                               , ReturnType (..)) where

import DataStruct.Ast.Type (VariableType (..))

data VariableValue =
  Bool Bool
  | String String
  | Int Int
  deriving (Show, Eq)

type VariableName = String

data VariableDef = VariableDef VariableName VariableType VariableValue

data ReturnType = Void | Value VariableType
