{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compile variables
-}

module Compiler.Variable ( Variable
                         , VariableStorage
                         , insertVariable'
                         , getVariable'
                         ) where
import DataStruct.Ast.Variable (VariableName)

import qualified Map.Map as Map
import DataStruct.Asm (Addr)

type Variable = (VariableName, Addr)
type VariableStorage = Map.Map VariableName Addr

insertVariable' :: VariableStorage -> Variable -> VariableStorage
insertVariable' s (name, value) = Map.set s name value

getVariable' :: VariableStorage -> VariableName -> Maybe Addr
getVariable' = Map.get
