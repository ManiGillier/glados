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
import DataStruct.Asm (Instruction (..))
import Compiler.Config (funcLabelPrefix)

compileFuncDef :: Compiler FunctionDef
compileFuncDef s (Function name _ vs body)
  | elem name $ functionNames s = Nothing
  | otherwise = flip apply s' $
    [Label $ funcLabelPrefix ++ name]
    <@ (mapCompiler compileVarDef, vs)
    .+ (compileFuncBody, body)
    @> [Ret]
    where s' = s { functionNames = name : functionNames s
                 , var = [] }

compileMainDef :: Compiler MainFunctionDef
compileMainDef s (Main vs body) = flip apply s'
  $ [Label $ funcLabelPrefix ++ "main", Label ".start"]
  <@ (mapCompiler compileVarDef, vs)
  .+ (compileFuncBody, body)
  @> [Ret]
    where s' = s { functionNames = "main" : functionNames s
                 , var = [] }
