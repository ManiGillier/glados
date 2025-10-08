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
  flip apply s
  $ (compileCondition, cond)
  .+ (compileFuncBody, body)
  .+ (compileFuncBody, elseBody)
compileFuncBodyContent s (If cond body Nothing) =
  flip apply s
  -- TODO: Change label name here
  $ (compileCondition, cond) @> [PushLabel "",Zjmp]
  .+ (compileFuncBody, body) @> [Label ""]
compileFuncBodyContent _ _ = Nothing

compileFuncBody :: Compiler FunctionBody
compileFuncBody = mapCompiler compileFuncBodyContent
