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
                     , apply, takeLabel, varExist, getVariable, revCompiler, callToContext, FunctionContext (FunctionContext), Context (functionDefs))
import DataStruct.Ast.Ast ( FunctionBody
                          , FunctionBodyContent (..))
import DataStruct.Asm (Instruction (..))
import Compiler.Config (funcLabelPrefix)
import Compiler.Condition (compileCondition)
import Error.MaybeError (MaybeError(Error, Correct))
import Error.ErrorList (ukVarErr, returnValueInVoidFunction)

-- TODO: Assign Return Value of Invoke to the set Variable
compileFuncBodyContent :: Compiler FunctionBodyContent
compileFuncBodyContent s (Return comp) = case functionDefs s of
  (FunctionContext name False:_) -> Error returnValueInVoidFunction name
  __ -> flip apply s $
    (compileComputable, comp) @> [ PopToStackPtrRel (-8), Ret ]
compileFuncBodyContent s (Show comp) = compiler s comp
  where compiler = suffixCompiler [Aff] compileComputable
compileFuncBodyContent s (ShowStr str) = Correct (s, [Affs str])
compileFuncBodyContent s (Invoke name args r@Nothing) = flip apply s'
  $ (comps, args)
  @> [ PushValue 0, PushLabel $ funcLabelPrefix ++ name, Call ]
  @> replicate (length args + 1) PopEmpty
  where comps = revCompiler $ mapCompiler compileComputable
        s' = callToContext s name args r
compileFuncBodyContent s (Invoke name args r@(Just varName))
  | varExist s varName = (getVariable s varName)
    >>= \varAddr -> flip apply s' $
    (comps, args)
    @> [ PushValue 0, PushLabel $ funcLabelPrefix ++ name, Call ]
    @> [ PopToStackPtrRel varAddr ] @> replicate (length args) PopEmpty
  | otherwise = Error ukVarErr varName
  where comps = revCompiler $ mapCompiler compileComputable
        s' = callToContext s name args r
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
compileFuncBodyContent s (Loop cond body) =
  flip apply s'' $
  [Label startLabel] <@ (compileCondition, cond) @> [PushLabel endLabel, Zjmp]
  .+ (compileFuncBody, body) @> [PushLabel startLabel, Jmp, Label endLabel]
  where (s', startLabel) = takeLabel "while" s
        (s'', endLabel) = takeLabel "while" s'
compileFuncBodyContent s (Assign name comp)
  | varExist s name = (getVariable s name) >>= \varAddr -> flip apply s $
    (compileComputable, comp) @> [PopToStackPtrRel varAddr]
  | otherwise = Error ukVarErr name

compileFuncBody :: Compiler FunctionBody
compileFuncBody = mapCompiler compileFuncBodyContent
