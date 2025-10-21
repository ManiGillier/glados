{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.Arithmetic (binOp, handleOp, handleBitshift) where 

import VM.Types
import VM.Utils.Conversion
import Error.MaybeError
import Error.ErrorList
import Data.Int (Int64)

binOp :: (Int64 -> Int64 -> Int64) -> Stack -> Bool -> MaybeError Stack
binOp _ [_] _ = Error stackError $ "underflow"
binOp _ [] _ = Error stackError $ "underflow"
binOp f xs safe = 
    let val1 = (bytesToInt64(take 8 $ drop 8 xs))
        val2 = (bytesToInt64(take 8 xs))
    in if not safe && val2 == 0 then Error divError $ "" 
        else
            Correct $ int64To8Bytes (f val1 val2 ) ++ drop 16 xs

handleOp :: (Int64 -> Int64 -> Int64) -> VMState -> Bool -> MaybeError VMState
handleOp f state safe =
    case binOp f (vmStack state) safe of
        Correct nst -> Correct $ state 
            { vmPC = nextIns (vmPC state), vmStack = nst }
        Error err msg -> Error err msg

handleBitshift ::(Int64 -> Int -> Int64) -> VMState -> VMState
handleBitshift f state =
    let stack = (vmStack state)
        val = (bytesToInt64(take 8 $ drop 8 stack)) 
        left = bytesToInt64 (take 8 stack)
        newVal = f val (fromIntegral left)
        newStack = (int64To8Bytes newVal) ++ (drop 16 stack)
    in state { vmPC = nextIns (vmPC state), vmStack = newStack }
