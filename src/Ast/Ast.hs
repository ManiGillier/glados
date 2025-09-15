{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Ast
-}

module Ast.Ast (SExpr(..))
    where

data SExpr = Int Int
            | Symbol String
            | Lists [SExpr]
            deriving (Show)
