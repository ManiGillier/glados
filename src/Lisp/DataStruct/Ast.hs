{--
-- EPITECH PROJECT, 2025
-- GLaDOS
-- File description:
-- Ast
--}

module Lisp.DataStruct.Ast (Ast (..)) where

data Ast = Symbol !String
           | Define !String !Ast
           | Lambda ![String] !Ast
           | Value !Int
           | Call !String ![Ast]
           | Apply !Ast ![Ast]
           deriving (Show)
