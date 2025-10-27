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
import Error.MaybeError
import Error.ErrorList
import VM.ByteCode
import Data.Int (Int64)

binComparator :: (Int64 -> Int64 -> Bool) -> Stack -> MaybeError Stack
binComparator _ [_] = Error stackError $ "underflow"
binComparator _ [] = Error stackError $ "underflow"
binComparator f xs = Correct $ int64To8Bytes
    (boolToInt64 $ 
        f (bytesToInt64(take 8 $ drop 8 xs)) (bytesToInt64(take 8 xs)) )
    ++ drop 16 xs

handleComp :: (Int64 -> Int64 -> Bool) -> VMState -> VMState
handleComp f state =
    case binComparator f (vmStack state) of
        Correct nst -> state 
            { vmPC = nextIns (vmPC state), vmStack = nst }
        Error err msg -> state 
            { vmIO = (vmIO state) ++ [(stderrFd, err ++ msg)]}

binBoolComparator :: (Bool -> Bool -> Bool) -> Stack -> MaybeError Stack
binBoolComparator _ [_] = Error stackError $ "underflow"
binBoolComparator _ [] = Error stackError $ "underflow"
binBoolComparator f xs = Correct $ int64To8Bytes
    (boolToInt64 $ f ((int64ToBool $ bytesToInt64(take 8 $ drop 8 xs)))
    (int64ToBool $ bytesToInt64(take 8 xs)))
    ++ drop 16 xs

handleBoolComp :: (Bool -> Bool -> Bool) -> VMState -> VMState
handleBoolComp f state =
    case binBoolComparator f (vmStack state) of
        Correct nst -> state 
            { vmPC = nextIns (vmPC state), vmStack = nst }
        Error err msg -> state
            { vmIO = (vmIO state) ++ [(stderrFd, err ++ msg)]}
