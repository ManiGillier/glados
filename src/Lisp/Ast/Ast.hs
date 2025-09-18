{--
-- EPITECH PROJECT, 2025
-- GLaDOS
-- File description:
-- Ast
--}

module Lisp.Ast.Ast (SExpr(..),
                    Symbol(),
                    Ast(..))
                    where

type Symbol = String


data SExpr = SInt Int
             | SSymbol Symbol
             | SList [SExpr]
             deriving (Show)

data Ast = ASymbol Symbol
           | Define Symbol Ast
           | Lambda [Symbol] Ast
           | Value Int
           | Call String [Ast] 
           | Apply Ast [Ast]
           deriving (Show)
