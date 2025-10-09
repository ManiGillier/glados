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
import DataStruct.Ast.Ast (FunctionDef (..), MainFunctionDef (..))
import Compiler.VariableDef (compileVarDef)
import Compiler.FunctionBody (compileFuncBody)
import DataStruct.Asm (Instruction (..), Addr)
import Compiler.Config (funcLabelPrefix)
import DataStruct.Ast.Variable (FuncParam (FuncParam))
import Compiler.Variable (VariableStorage, Variable, insertVariable')

computeParam :: Addr -> FuncParam -> Variable
computeParam addr (FuncParam name _) = (name,addr - 8)

computeParams :: Addr -> [FuncParam] -> VariableStorage
computeParams _ [] = []
computeParams addr (x:xs) = insertVariable'
  (computeParams (addr - 8) xs) $ computeParam addr x

compileFuncDef :: Compiler FunctionDef
compileFuncDef s (Function name _ ps vs body)
  | elem name $ functionNames s = Nothing
  | otherwise = flip apply s' $
    [Label $ funcLabelPrefix ++ name]
    <@ (mapCompiler compileVarDef, vs)
    .+ (compileFuncBody, body)
    @> [Ret]
    where s' = s { functionNames = name : functionNames s
                 , var = computeParams 0 ps }

compileMainDef :: Compiler MainFunctionDef
compileMainDef s (Main vs body) = flip apply s'
  $ [Label $ funcLabelPrefix ++ "main", Label ".start"]
  <@ (mapCompiler compileVarDef, vs)
  .+ (compileFuncBody, body)
  @> [Ret]
    where s' = s { functionNames = "main" : functionNames s
                 , var = [] }
