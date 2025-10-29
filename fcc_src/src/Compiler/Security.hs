{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler security features
-}

module Compiler.Security ( checkFunctionCall
  ) where
import Compiler.Type (Context (Context))
import DataStruct.Asm (Instruction)
import Error.MaybeError (MaybeError (..))
import DataStruct.Ast.Ast (FunctionName)
import Error.ErrorList (undefinedFunctionErr)

callsToUndefinedFunction :: [FunctionName] -> [FunctionName]
  -> Maybe String
callsToUndefinedFunction _ [] = Nothing
callsToUndefinedFunction defs (call:calls)
  | elem call defs = callsToUndefinedFunction defs calls
  | otherwise = Just call

checkFunctionCall :: (Context, [Instruction])
  -> MaybeError (Context, [Instruction])
checkFunctionCall a@(Context _ _ defs calls,_) =
  case callsToUndefinedFunction defs calls of
    Nothing -> Correct a
    Just e -> Error undefinedFunctionErr e
