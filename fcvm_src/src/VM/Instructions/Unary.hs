{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.Unary (
    handleNegate
    ,handleNot
    ,handleBinNot) 
    where 

import VM.Types
import VM.Utils.Conversion
import VM.ByteCode
import VM.Stack
import Data.Bits (Bits(complement))

handleNegate :: VMState -> VMState
handleNegate state = 
    let stack = (vmStack state)
        val = bytesToInt64 (take 8 stack)
        newVal = int64To8Bytes (-val)
        newStack = newVal ++ (popStack stack)
    in state { vmPC = nextIns (vmPC state), vmStack = newStack }

handleNot :: VMState -> VMState
handleNot state =
    let stack = (vmStack state)
        val = bytesToInt64 (take 8 stack)
        boolVal = int64ToBool val 
        newVal = int64To8Bytes (boolToInt64 (not boolVal))
        newStack = newVal ++ (popStack stack)
    in state { vmPC = nextIns (vmPC state), vmStack = newStack }

handleBinNot :: VMState -> VMState
handleBinNot state =
    let stack = (vmStack state)
        val = bytesToInt64 (take 8 stack)
        newVal = int64To8Bytes (complement val)
        newStack = newVal ++ (popStack stack)
    in state { vmPC = nextIns (vmPC state), vmStack = newStack }
