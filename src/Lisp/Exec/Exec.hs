{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec 
-}

module Lisp.Exec.Exec () where

import Lisp.Exec.Builtin
import Lisp.Ast.Ast

-- Main exec function
execLisp :: Ast -> Maybe Int
execLisp _ = Just (add 10 2)
