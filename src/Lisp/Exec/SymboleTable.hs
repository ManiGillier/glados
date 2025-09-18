{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- SymTable 
-}

module Lisp.Exec.SymboleTable (SymTable,
                               Value(..))
                               where
import Lisp.DataStruct.Ast

type SymTable = [(String, Value)]

data Value = VInt Int
           | VLambda [String] Ast SymTable
           | VError String
           deriving (Show)
