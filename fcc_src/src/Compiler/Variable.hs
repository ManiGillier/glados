{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compile variables
-}

module Compiler.Variable ( Variable
                         , VariableStorage
                         , insertVariable
                         , getVariable
                         , emptyStorage
                         ) where
import DataStruct.Ast.Variable (VariableValue, VariableName)

import qualified Map.Map as Map

type Variable = (VariableName, VariableValue)
type VariableStorage = Map.Map VariableName VariableValue

insertVariable :: VariableStorage -> Variable -> VariableStorage
insertVariable s (name, value) = Map.set s name value

getVariable :: VariableStorage -> VariableName -> Maybe VariableValue
getVariable = Map.get

emptyStorage :: VariableStorage
emptyStorage = []
