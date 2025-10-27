{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiling of variable definitions
-}

module Compiler.VariableDef (compileVarDef) where
import Compiler.Type (Compiler, varExist, insertVariable, Context (var))
import DataStruct.Ast.Variable as V (VariableDef (..))
import Compiler.Variable (getStorageSize)
import DataStruct.Asm (Instruction(PushValue))
import Error.MaybeError (MaybeError(Correct, Error))
import Error.ErrorList (alreadyDefVarErr)

compileVarDef :: Compiler VariableDef
compileVarDef s (VariableDef n v)
  | varExist s n = Error alreadyDefVarErr n
  | otherwise = Correct $
    (insertVariable s (n, addr), [PushValue v])
    where addr = getStorageSize $ var s
