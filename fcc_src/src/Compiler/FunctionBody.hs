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
                     -- , (<@)
                     , (@>)
                     , apply, takeLabel)
import DataStruct.Ast.Ast ( FunctionBody
                          , FunctionBodyContent (..))
import DataStruct.Asm (Instruction (..))
import Compiler.Config (funcLabelPrefix)
import Compiler.Condition (compileCondition)

compileFuncBodyContent :: Compiler FunctionBodyContent
compileFuncBodyContent s (Return comp) = compiler s comp
  where compiler = suffixCompiler [Ret] compileComputable
compileFuncBodyContent s (Show comp) = compiler s comp
  where compiler = suffixCompiler [Aff] compileComputable
compileFuncBodyContent s (Invoke name args) = suffixCompiler
        [ PushLabel $ funcLabelPrefix ++ name
        , Call
        ] comps s args
  where comps = mapCompiler compileComputable
compileFuncBodyContent s (If cond body (Just elseBody)) =
  flip apply s''
  $ (compileCondition, cond) @> [PushLabel label,Zjmp]
  .+ (compileFuncBody, body) @> [PushLabel labelEnd, Jmp, Label label]
  .+ (compileFuncBody, elseBody) @> [Label labelEnd]
  where (s', label) = takeLabel "if" s
        (s'', labelEnd) = takeLabel "if" s'
compileFuncBodyContent s (If cond body Nothing) =
  flip apply s'
  $ (compileCondition, cond) @> [PushLabel label,Zjmp]
  .+ (compileFuncBody, body) @> [Label label]
  where (s', label) = takeLabel "if" s
compileFuncBodyContent _ _ = Nothing

compileFuncBody :: Compiler FunctionBody
compileFuncBody = mapCompiler compileFuncBodyContent
