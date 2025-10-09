{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiling of variable definitions
-}

module Compiler.VariableDef (compileVarDef) where
import Compiler.Type (Compiler, varExist, insertVariable, Context (var))
import DataStruct.Ast.Variable as V (VariableDef (..), VariableValue (..))
import DataStruct.Ast.Type as T (VariableType (..))
import Compiler.Variable (getStorageSize)
import DataStruct.Asm (Instruction(PushValue))

compileVarDef :: Compiler VariableDef
compileVarDef s (VariableDef n (T.Int) (V.Int v))
  | varExist s n = Nothing
  | otherwise = Just $
    (insertVariable s (n, addr), [PushValue v])
    where addr = getStorageSize $ var s
compileVarDef _ _ = Nothing
