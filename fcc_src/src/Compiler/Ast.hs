{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Ast compilation
-}

module Compiler.Ast ( compile ) where
import Compiler.Type (Compiler, apply, mapCompiler, baseContext
                     , (.+), compileMaybe)
import DataStruct.Ast.Ast (Ast (..))
import Compiler.FunctionDef (compileMainDef, compileFuncDef)
import DataStruct.Asm (Instruction)
import Error.MaybeError (MaybeError)

compile :: Ast -> MaybeError [Instruction]
compile ast = snd <$> compileAst baseContext ast

compileAst :: Compiler Ast
compileAst s (Ast main funcs) = flip apply s $
  (compileMaybe compileMainDef, main)
  .+ (mapCompiler compileFuncDef, funcs)
