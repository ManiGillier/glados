{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler type
-}

module Compiler.Type (Compiler, combine) where
import Compiler.Variable (VariableStorage)
import DataStruct.Asm (Instruction)

type Compiler a = VariableStorage -> a -> Maybe (VariableStorage, [Instruction])

{-
combine :: Compiler a -> a -> Compiler b -> b
  -> VariableStorage -> Maybe (VariableStorage, [Instruction])
combine ca a cb b s = ra >>= (\(s',ra') -> compile cb b s'
                               >>= (\(s'',rb') -> Just (s'',ra' ++ rb')))
  where ra = compile ca a s
-}

combine :: Compiler a -> Compiler b -> Compiler (a,b)
combine ca cb =
  \s (a,b) -> ca s a >>= (
    \(s',ra') -> cb s' b >>= (
      \(s'',rb) -> Just (s'', (ra' ++ rb))))
