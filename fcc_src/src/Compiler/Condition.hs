{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- condition compiler
-}

module Compiler.Condition (compileCondition) where
import Compiler.Type (Compiler)
import Compiler.Operation (compileComputable)
import DataStruct.Ast.Ast (Condition (Condition))

compileCondition :: Compiler Condition
compileCondition s (Condition cond) = compiler s cond
-- TODO: Add the new INSTRUCTION here
  where compiler = compileComputable
