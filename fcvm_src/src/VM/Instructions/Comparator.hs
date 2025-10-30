{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.Comparator (
    handleComp
    ,handleBoolComp)
    where

import VM.Types
import VM.Utils.Conversion
import Error.ErrorList
import VM.ByteCode
import VM.Stack
import Data.Int (Int64)

binComparator :: (Int64 -> Int64 -> Bool) -> Stack -> Stack
binComparator f xs = int64To8Bytes
    (boolToInt64 $ 
        f (bytesToInt64(take 8 $ drop 8 xs)) (bytesToInt64(take 8 xs)) )
    ++ drop 16 xs

handleComp :: (Int64 -> Int64 -> Bool) -> VMState -> VMState
handleComp f state
    | isUnderFlow state = state
            { vmIO = (vmIO state) ++ [(stderrFd, stackUnderFlowError)]}
    | otherwise = 
        state { vmPC = nextIns (vmPC state), 
        vmStack = binComparator f (vmStack state)}

binBoolComparator :: (Bool -> Bool -> Bool) -> Stack -> Stack
binBoolComparator f xs = int64To8Bytes
    (boolToInt64 $ f ((int64ToBool $ bytesToInt64(take 8 $ drop 8 xs)))
    (int64ToBool $ bytesToInt64(take 8 xs)))
    ++ drop 16 xs

handleBoolComp :: (Bool -> Bool -> Bool) -> VMState -> VMState
handleBoolComp f state
    | isUnderFlow state = state
            { vmIO = (vmIO state) ++ [(stderrFd, stackUnderFlowError)]}
    | otherwise = 
        state { vmPC = nextIns (vmPC state), 
        vmStack = binBoolComparator f (vmStack state)}
