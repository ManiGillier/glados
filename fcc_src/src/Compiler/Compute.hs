{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler of computables
-}

module Compiler.Compute (compileComputable) where

import DataStruct.Ast.Ast as Ast
import DataStruct.Asm as Asm
import DataStruct.Ast.Variable (VariableValue(Int, Bool))
import qualified Compiler.Operation as Op

compileComputable :: Computable -> Maybe [Instruction]
-- Computable Value
compileComputable (Value (Int a)) = Just $ [PushValue a]
compileComputable (Value (Bool False)) = Just $ [PushValue 0]
compileComputable (Value (Bool True)) = Just $ [PushValue 1]
compileComputable (Value _) = Nothing
-- Computable Variable
compileComputable (Ast.Variable _) = error $ "TODO: Implement variable"
-- Computable Operation
compileComputable (Ast.Operation op) = Op.compileOperation op
compileComputable _ = Nothing
