{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- ast variable
-}

module DataStruct.Ast.Variable ( VariableName
                               , VariableDef (..)
                               , FuncParam (..)
                               ) where

import Data.Int (Int64)

type VariableName = String

data VariableDef = VariableDef VariableName Int64
  deriving (Eq, Show)

data FuncParam = FuncParam VariableName
  deriving (Eq, Show)
