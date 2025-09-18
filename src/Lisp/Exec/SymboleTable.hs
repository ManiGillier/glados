{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- SymTable 
-}

module Lisp.Exec.SymboleTable (SymTable,
                               Value(..))
                               where
import Lisp.Ast.Ast

type SymTable = [(Symbol, Value)]

data Value = VInt Int
           | VLambda [Symbol] Ast SymTable
           | VError String
           deriving (Show)
