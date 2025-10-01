{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler of operations
-}

module Compiler.Operation ( compileOperation
                          , compileComputable) where

import DataStruct.Ast.Ast as Ast
import DataStruct.Asm as Asm
import DataStruct.Ast.Variable (VariableValue(Int, Bool))

compileComputable :: Computable -> Maybe [Instruction]
-- Computable Value
compileComputable (Value (Int a)) = Just $ [PushValue a]
compileComputable (Value (Bool False)) = Just $ [PushValue 0]
compileComputable (Value (Bool True)) = Just $ [PushValue 1]
compileComputable (Value _) = Nothing
-- Computable Variable
compileComputable (Ast.Variable _) = error $ "TODO: Implement variable"
-- Computable Operation
compileComputable (Ast.Operation op) = compileOperation op
-- compileComputable _ = Nothing

compileOperation :: Operation -> Maybe [Instruction]
compileOperation _ = Nothing
