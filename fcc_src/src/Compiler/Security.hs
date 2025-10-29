{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler security features
-}

module Compiler.Security ( checkFunctionCall
  ) where
import Compiler.Type (Context (Context), FunctionContext (..))
import DataStruct.Asm (Instruction)
import Error.MaybeError (MaybeError (..))
import Error.ErrorList (undefinedFunctionErr)

callsToUndefinedFunction :: [FunctionContext] -> [FunctionContext]
  -> Maybe String
callsToUndefinedFunction _ [] = Nothing
callsToUndefinedFunction defs (call:calls)
  | elem name names = callsToUndefinedFunction defs calls
  | otherwise = Just name
  where name = funcName call
        names = map funcName defs

checkFunctionCall :: (Context, [Instruction])
  -> MaybeError (Context, [Instruction])
checkFunctionCall a@(Context _ _ defs calls,_) =
  case callsToUndefinedFunction defs calls of
    Nothing -> Correct a
    Just e -> Error undefinedFunctionErr e
