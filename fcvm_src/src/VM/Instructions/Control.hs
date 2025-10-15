{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.Control (handleCall, handleRet) where 

import VM.Types
import VM.CallStack
import VM.Stack
import VM.Labels 

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
