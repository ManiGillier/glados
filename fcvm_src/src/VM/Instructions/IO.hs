{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.IO (handleAff) where 

import VM.Types
import VM.Utils.Conversion
import VM.Stack
import Data.Char
import VM.ByteCode

handleAff :: VMState -> VMState
handleAff state =
    let val = chr $ fromIntegral $ bytesToInt64 (take bits64 (vmStack state))
        newStack = popStack (vmStack state)
        newState = state { vmPC = nextIns (vmPC state), vmStack = newStack, 
            vmIO = [(stdoutFd, [val])]}
    in newState
