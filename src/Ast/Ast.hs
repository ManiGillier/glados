{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Ast
-}

module Ast.Ast (SExpr(..))
    where

datatype Symbol = String

data SExpr = Int Int
            | Symbol Symbol
            | List [SExpr]
            deriving (Show)

data Ast = Symbol String
  | Define Symbol Ast
  | Lambda [Symbol] Ast
  | Value Int
  | Call Symbol [Ast]
