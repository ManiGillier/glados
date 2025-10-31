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
import VM.Utils.Conversion
import Data.Int (Int64)
import Data.Word (Word8)

takeEnd :: Int -> [a] -> [a]
takeEnd i l = drop (length l - i) l

handleCall :: VMState -> VMState
handleCall state =
    let newStack = popStack (vmStack state)
        newSP = length newStack
        newPC = fromIntegral $ bytesToInt64 $ take 8 (vmStack state)
        newCallStack = updateCall (vmPC state) (vmSP state) (vmCallStack state)
    in state { vmPC = newPC, vmStack = newStack, 
        vmSP = newSP, vmCallStack = newCallStack, 
        vmCallSackSize = (vmCallSackSize state + 1),
        vmStackSize = (vmStackSize state - 1)}

getReturnValue :: Stack -> Int64
getReturnValue [] = (-1)
getReturnValue st = bytesToInt64 (drop (length st - 8) st)

handleRet :: VMState -> VMState
handleRet state =
    let ((npc, nsp), ncs) = restoreStack (vmCallStack state)
    in case ((npc, nsp), ncs) of
        ((0, 0), []) -> state { vmEnd = False,
            vmRetVal = (Just $ getReturnValue (vmStack state))}
        _ -> state { vmPC = npc, vmSP = nsp, vmCallStack = ncs,
                    vmStack = takeEnd (vmSP state) $ vmStack state,
                    vmCallSackSize = (vmCallSackSize state - 1)}

zfVal :: Int64 -> Word8
zfVal 0 = 0
zfVal _ = 1

handleZflag :: VMState -> VMState
handleZflag state = 
    let stack = (vmStack state)
        pc = (vmPC state) + 1
        zflag = bytesToInt64 (take 8 stack)
    in state { vmPC = pc, vmStack = popStack stack 
        ,vmStackSize = (vmStackSize state - 1)
        ,vmZFlag = zfVal zflag }

handleZjmp :: VMState -> VMState
handleZjmp state =
    let stack = (vmStack state)
        zflag = (vmZFlag state)
        pc = (vmPC state)
        newPc = fromIntegral $ bytesToInt64 $ take 8 stack
        newStSize = (vmStackSize state - 1)
    in case zflag of
        0 -> state {vmStack = popStack stack, vmPC = newPc, 
            vmStackSize = newStSize}
        _ -> state {vmStack = popStack stack, vmPC = pc + 1, 
            vmStackSize = newStSize}

handleJmp :: VMState -> VMState
handleJmp state =
    let stack = (vmStack state)
        newPc = fromIntegral $ bytesToInt64 $ take 8 stack
        newStSize = (vmStackSize state - 1)
    in state {vmStack = popStack stack, 
        vmPC = newPc, vmStackSize = newStSize}
