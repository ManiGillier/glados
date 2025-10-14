{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Ast compilation
-}

module Compiler.Ast ( compile ) where
import Compiler.Type (Compiler, apply, mapCompiler, baseContext
                     , (.+))
import DataStruct.Ast.Ast (CombinedAst (CAst))
import Compiler.FunctionDef (compileMainDef, compileFuncDef)
import DataStruct.Asm (Instruction)
import Error.MaybeError (MaybeError)

compile :: CombinedAst -> MaybeError [Instruction]
compile ast = snd <$> compileAst baseContext ast

compileAst :: Compiler CombinedAst
compileAst s (CAst main funcs) = flip apply s $
  (compileMainDef, main)
  .+ (mapCompiler compileFuncDef, funcs)
