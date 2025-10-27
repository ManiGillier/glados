{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.IO (handleAff, handleAffs) where 

import VM.Types
import VM.Utils.Conversion
import VM.Stack
import Data.Char
import VM.ByteCode
import Data.Word 

handleAff :: VMState -> VMState
handleAff state =
    let val = chr $ fromIntegral $ bytesToInt64 (take bits64 (vmStack state))
        newStack = popStack (vmStack state)
        newState = state { vmPC = nextIns (vmPC state), vmStack = newStack, 
            vmIO = [(stdoutFd, [val])]}
    in newState

word8ToString :: [Word8] -> String
word8ToString = map (chr . fromIntegral)

handleAffs:: VMState -> VMState
handleAffs state =
    let len = bytesToInt64 (take 8 (drop (vmPC state + 1) (vmByteCode state)))
        str = word8ToString (take (fromIntegral len) 
            (drop ((vmPC state) + 9) (vmByteCode state)))
        jmp = len + 9
        newPc = (fromIntegral (vmPC state)) + jmp
        newState = state 
            { vmPC = (fromIntegral newPc), vmIO = [(stdoutFd, str)] }
    in newState

