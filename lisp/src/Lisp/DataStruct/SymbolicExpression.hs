{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- symbolic expressions
-}

module Lisp.DataStruct.SymbolicExpression ( SExpr(..) ) where

data SExpr = Value !Int
             | Symbol !String
             | List ![SExpr]
             deriving (Show)
