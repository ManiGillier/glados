{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- function body compiler
-}

module Compiler.FunctionBody where
import Compiler.Operation (compileComputable)
import Compiler.Type (Compiler, suffixCompiler, mapCompiler)
import DataStruct.Ast.Ast (FunctionBody (..), a)
import DataStruct.Asm (Instruction (..))
import Compiler.Config (funcLabelPrefix)

compileFuncBody :: Compiler FunctionBody
compileFuncBody s (Return comp) = compiler s comp
  where compiler = suffixCompiler [Ret] compileComputable
compileFuncBody s (Show comp) = compiler s comp
  where compiler = suffixCompiler [Aff] compileComputable
compileFuncBody s (Invoke name args) = suffixCompiler
        [ PushLabel $ funcLabelPrefix ++ name
        , Call
        ] comps s args
  where comps = mapCompiler compileComputable
compileFuncBody _ _ = Nothing
