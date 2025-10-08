{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- function body compiler
-}

module Compiler.FunctionBody (compileFuncBody) where
import Compiler.Operation (compileComputable)
import Compiler.Type (Compiler, suffixCompiler, mapCompiler
                     , (.+)
                     , (<@)
                     , (@>)
                     , apply)
import DataStruct.Ast.Ast (FunctionBody (..))
import DataStruct.Asm (Instruction (..))
import Compiler.Config (funcLabelPrefix)
import Compiler.Condition (compileCondition)

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
compileFuncBody s (If cond body (Just elseBody)) =
  flip apply s
  $ (compileCondition, cond)
  .+ (compileFuncBody, body)
  .+ (compileFuncBody, elseBody)
compileFuncBody s (If cond body Nothing) =
  flip apply s
  -- TODO: Change label name here
  $ (compileCondition, cond) @> [PushLabel "",Jmp]
  .+ (compileFuncBody, body) @> [Label ""]
compileFuncBody _ _ = Nothing
