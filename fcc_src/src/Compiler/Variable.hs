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
                         , varExist'
                         , getStorageSize
                         ) where
import DataStruct.Ast.Variable (VariableName)

import qualified Map.Map as Map
import DataStruct.Asm (Addr)
import Data.Int (Int64)

type Variable = (VariableName, Addr)
type VariableStorage = Map.Map VariableName (Addr, Int64)

varExist' :: VariableStorage -> VariableName -> Bool
varExist' = Map.contains

insertVariable' :: VariableStorage -> Variable -> VariableStorage
insertVariable' s (name, value) = Map.set s name (value, 8)

getVariable' :: VariableStorage -> VariableName -> Maybe Addr
getVariable' s n = fmap fst $ Map.get s n

getStorageSize :: VariableStorage -> Int64
getStorageSize [] = 0
getStorageSize [(_,(pos,size))] = pos + size
getStorageSize (_:xs) = getStorageSize xs
