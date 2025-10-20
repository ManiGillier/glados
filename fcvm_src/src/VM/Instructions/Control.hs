{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.Control (
    handleCall
    ,handleRet
    ,handleZflag
    ,handleZjmp
    ,handleJmp)
    where 

import VM.Types
import VM.CallStack
import VM.Stack
import VM.Labels 
import VM.Utils.Conversion
import Data.Int (Int64)
import Data.Word (Word8)

handleCall :: VMState -> VMState
handleCall state =
    let newStack = popStack (vmStack state)
        newSP = length newStack
        newPC = getPc (vmStack state) (vmLabels state)
        newCallStack = updateCall (vmPC state) (vmSP state) (vmCallStack state)
    in state { vmPC = newPC, vmStack = newStack, 
        vmSP = newSP, vmCallStack = newCallStack }

handleRet :: VMState -> Maybe VMState
handleRet state =
    let ((npc, nsp), ncs) = restoreStack (vmCallStack state)
    in case ((npc, nsp), ncs) of
        ((0, 0), []) -> Nothing
        _ -> Just $ state { vmPC = npc, vmSP = nsp, vmCallStack = ncs }

zfVal :: Int64 -> Word8
zfVal 0 = 0
zfVal _ = 1

handleZflag :: VMState -> VMState
handleZflag state = 
    let stack = (vmStack state)
        pc = (vmPC state) + 1
        zflag = bytesToInt64 (drop 8 stack)
    in state { vmPC = pc, vmStack = popStack stack 
        ,vmZFlag = zfVal zflag }

handleZjmp :: VMState -> VMState
handleZjmp state =
    let stack = (vmStack state)
        zflag = (vmZFlag state)
        pc = (vmPC state)
    in case zflag of 
        0 -> state {vmStack = popStack stack, 
            vmPC = getPc stack (vmLabels state) }
        _ -> state {vmStack = popStack stack, vmPC = pc + 1}

handleJmp :: VMState -> VMState
handleJmp state =
    let stack = (vmStack state)
    in state {vmStack = popStack stack, 
        vmPC = getPc stack (vmLabels state) }
