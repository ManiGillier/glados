{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Instructions.Stack (
     handlePushValue
    ,handlePopToStackPtrRel
    ,handlePushFromStackPtrRel
    ,handlePopEmpty)
    where

import VM.Types
import VM.Stack
import VM.ByteCode
import VM.Utils.Conversion

handlePushValue :: VMState -> VMState
handlePushValue state =
    let newStack = pushAddrStack (vmStack state) $ 
            drop (nextIns (vmPC state)) (vmByteCode state)
    in state { vmPC = skipVal (vmPC state), vmStack = newStack }

handlePopEmpty :: VMState -> VMState
handlePopEmpty state =
    let newStack = popStack (vmStack state)
    in state { vmPC = nextIns (vmPC state), vmStack = newStack }

handlePopToStackPtrRel :: VMState -> VMState
handlePopToStackPtrRel state =
    let addr = fromIntegral $ bytesToInt64 
            (take bits64 $ drop (nextIns (vmPC state)) (vmByteCode state))
        newStack = popToStackPtrRel (vmStack state) (vmSP state) addr
    in state { vmPC = skipVal (vmPC state), vmStack = newStack }

handlePushFromStackPtrRel :: VMState -> VMState
handlePushFromStackPtrRel state =
    let addr = fromIntegral $ bytesToInt64 
            (take bits64 $ drop (nextIns (vmPC state)) (vmByteCode state))
        newStack = pushFromStackPtrRel (vmStack state) (vmSP state) addr
    in state { vmPC = skipVal (vmPC state), vmStack = newStack }
