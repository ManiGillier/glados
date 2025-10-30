{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler security features
-}

module Compiler.Security ( checkFunctionCall
                         , getFunctionDefFromName
                         , returnValueCheckSingle
                         ) where
import Compiler.Type (Context (Context), FunctionContext (..))
import DataStruct.Asm (Instruction)
import Error.MaybeError (MaybeError (..))
import Error.ErrorList (undefinedFunctionErr, assignementFromVoidFunc, functionArgumentMissmatch)
import DataStruct.Ast.Ast (FunctionName)
import Data.Maybe (catMaybes)

getFunctionDefFromName :: [FunctionContext] -> FunctionName
  -> Maybe FunctionContext
getFunctionDefFromName [] _ = Nothing
getFunctionDefFromName (x:xs) name
  | name == funcName x = Just x
  | otherwise = getFunctionDefFromName xs name

callsToUndefinedFunction :: [FunctionContext] -> [FunctionContext]
  -> Maybe String
callsToUndefinedFunction _ [] = Nothing
callsToUndefinedFunction defs (call:calls)
  | elem name names = callsToUndefinedFunction defs calls
  | otherwise = Just name
  where name = funcName call
        names = map funcName defs

returnValueCheckSingle :: [FunctionContext] -> FunctionContext -> Maybe String
returnValueCheckSingle defs call = getFunctionDefFromName defs name
  >>= (\context -> if not (returning context) && returning call
        then Just $ funcName context
        else Nothing)
  where name = funcName call

checkSingleFunctionCallParam :: [FunctionContext] -> FunctionContext
  -> Maybe (String, Int, Int)
checkSingleFunctionCallParam defs (FunctionContext name _ count)
  = getFunctionDefFromName defs name
  >>= (\(FunctionContext _ _ count') -> if count /= count'
        then Just (name, count, count')
        else Nothing)

returnValueCheck :: [FunctionContext] -> [FunctionContext] -> [String]
returnValueCheck defs c = catMaybes r
  where r = map (returnValueCheckSingle defs) c

checkFunctionCallParams' :: [FunctionContext] -> [FunctionContext]
  -> [(String, Int, Int)]
checkFunctionCallParams' defs c = catMaybes r
  where r = map (checkSingleFunctionCallParam defs) c

checkFunctionCallUndefinedFunc :: (Context, [Instruction])
  -> MaybeError (Context, [Instruction])
checkFunctionCallUndefinedFunc a@(Context _ _ defs calls,_) =
  case callsToUndefinedFunction defs calls of
    Nothing -> Correct a
    Just e -> Error undefinedFunctionErr e

checkFunctionCallReturnValue :: (Context, [Instruction])
  -> MaybeError (Context, [Instruction])
checkFunctionCallReturnValue a@(Context _ _ defs calls,_) =
  case returnValueCheck defs calls of
    [] -> Correct a
    (x:_) -> Error assignementFromVoidFunc x

checkFunctionCallParams :: (Context, [Instruction])
  -> MaybeError (Context, [Instruction])
checkFunctionCallParams a@(Context _ _ defs calls,_) =
  case checkFunctionCallParams' defs calls of
    [] -> Correct a
    ((name, count, count'):_) -> Error functionArgumentMissmatch
        (name ++ ": got " ++ show count ++ " but expected " ++ show count')

checkFunctionCall :: (Context, [Instruction])
  -> MaybeError (Context, [Instruction])
checkFunctionCall c = checkFunctionCallUndefinedFunc c
  >>= checkFunctionCallReturnValue
  >>= checkFunctionCallParams
