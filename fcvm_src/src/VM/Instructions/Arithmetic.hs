{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.Arithmetic (binOp, handleOp) where 

import VM.Types
import VM.Utils.Conversion
import Error.MaybeError
import Error.ErrorList
import Data.Int (Int64)

binOp :: (Int64 -> Int64 -> Int64) -> Stack -> MaybeError Stack
binOp _ [_] = Error stackError $ "underflow"
binOp _ [] = Error stackError $ "underflow"
binOp f xs = Correct $ int64To8Bytes
    (f (bytesToInt64(take 8 $ drop 8 xs)) (bytesToInt64(take 8 xs)) )
    ++ drop 16 xs

handleOp :: (Int64 -> Int64 -> Int64) -> VMState -> MaybeError VMState
handleOp f state =
    case binOp f (vmStack state) of
        Correct nst -> Correct $ state 
            { vmPC = nextIns (vmPC state), vmStack = nst }
        Error err msg -> Error err msg
