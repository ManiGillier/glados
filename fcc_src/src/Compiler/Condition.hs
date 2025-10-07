{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- condition compiler
-}

module Compiler.Condition (compileCondition) where
import Compiler.Type (Compiler, suffixCompiler)
import Compiler.Operation (compileComputable)
import DataStruct.Ast.Ast (Condition (Condition))
import DataStruct.Asm (Instruction (Negate))

compileCondition :: Compiler Condition
compileCondition s (Condition cond) = compiler s cond
  where compiler = suffixCompiler [Negate] compileComputable
