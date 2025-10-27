{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compile function def
-}

module Compiler.FunctionDef ( compileFuncDef
                            , compileMainDef
                            ) where

import Compiler.Type (Compiler, Context (functionNames, var)
                     , apply, mapCompiler
                     , (.+), (<@), (@>))
import DataStruct.Ast.Ast (FunctionDef (..), MainFunctionDef (..), IsReturning)
import Compiler.VariableDef (compileVarDef)
import Compiler.FunctionBody (compileFuncBody)
import DataStruct.Asm (Instruction (..), Addr)
import Compiler.Config (funcLabelPrefix)
import DataStruct.Ast.Variable (FuncParam (FuncParam), VariableName)
import Compiler.Variable (VariableStorage, Variable, insertVariable')
import Error.MaybeError (MaybeError(Error))
import Error.ErrorList (alreadyDefFuncErr, alreadyDefVarErr)
import Data.Maybe (fromJust, isJust)

computeParam :: Addr -> FuncParam -> Variable
computeParam addr (FuncParam name) = (name,addr - 8)

computeParams :: Addr -> [FuncParam] -> VariableStorage
computeParams _ [] = []
computeParams addr (x:xs) = insertVariable'
  (computeParams (addr - 8) xs) $ computeParam addr x

prioritizeJust :: Maybe a -> Maybe a -> Maybe a
prioritizeJust (Just a) _ = Just a
prioritizeJust _ (Just a) = Just a
prioritizeJust _ _ = Nothing

checkDuplicatesParams :: [FuncParam] -> Maybe VariableName
checkDuplicatesParams [] = Nothing
checkDuplicatesParams [_] = Nothing
checkDuplicatesParams (x0'@(FuncParam x0):x1'@(FuncParam x1):xs)
  | x0 == x1 = Just x0
  | otherwise = checkDuplicatesParams (x0':xs)
                `prioritizeJust` checkDuplicatesParams (x1':xs)

removeVar :: (Context, [Instruction])
  -> (Context, [Instruction])
removeVar (c, i) = (c { var = [] }, i)

returnStatement :: IsReturning -> [Instruction]
returnStatement True = [PushValue 0, PopToStackPtrRel (-8), Ret]
returnStatement False = [Ret]

compileFuncDef :: Compiler FunctionDef
compileFuncDef s (Function name isReturning ps vs body)
  | elem name $ functionNames s = Error alreadyDefFuncErr name
  | isJust duplParam = Error alreadyDefVarErr $ fromJust duplParam
  | otherwise = removeVar <$> (flip apply s' $
    [Label $ funcLabelPrefix ++ name] <@ (mapCompiler compileVarDef, vs)
    .+ (compileFuncBody, body) @> returnStatement isReturning)
    where duplParam = checkDuplicatesParams ps
          s' = s { functionNames = name : functionNames s
                 , var = computeParams (-8) ps }

compileMainDef :: Compiler MainFunctionDef
compileMainDef s (Main vs body) = flip apply s'
  $ [Label $ funcLabelPrefix ++ "main", Label ".start"]
  <@ (mapCompiler compileVarDef, vs)
  .+ (compileFuncBody, body)
  @> [Ret]
    where s' = s { functionNames = "main" : functionNames s
                 , var = [] }
