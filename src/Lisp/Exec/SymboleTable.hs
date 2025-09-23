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
           | VBool Bool
           | VLambda [String] Ast SymTable
           | VError String
           deriving (Show, Eq)
