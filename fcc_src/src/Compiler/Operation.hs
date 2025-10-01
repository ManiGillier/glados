{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler of operations
-}

module Compiler.Operation (compileOperation) where


import DataStruct.Ast.Ast as Ast
import DataStruct.Asm as Asm
import DataStruct.Ast.Variable (VariableValue(Int, Bool))
import qualified Compiler.Compute as Compute
