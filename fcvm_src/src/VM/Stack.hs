{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Stack (
     pushAddrStack
    ,popStack
    ,popToStackPtrRel
    ,pushFromStackPtrRel
    ,isStackOverFlow
    ,isUnderFlow
    ) 
    where 

import VM.Types
import VM.Utils.Conversion

pushAddrStack :: Stack -> ByteCode -> Stack
pushAddrStack st val = take 8 val ++ st

popStack :: Stack -> Stack
popStack xs = drop 8 xs

popToStackPtrRel :: Stack -> SP -> Int -> Stack
popToStackPtrRel st sp addr =
    let val = take 8 st
        newSt = drop 8 st
        target = length newSt
    in sublist 0 (target - 8 - (sp + addr)) newSt ++ val 
    ++ sublist (target - (sp + addr)) (length newSt) newSt

pushFromStackPtrRel :: Stack -> SP -> Int -> Stack
pushFromStackPtrRel st sp addr =
    let target = ((length st) - 8 -(sp + addr))
        val = sublist target (target + 8) st
    in val ++ st

maxStackSize :: StackSize
maxStackSize = 1000000

isStackOverFlow :: VMState -> Bool
isStackOverFlow state
    | ((vmStackSize state) >= maxStackSize) 
        || ((vmCallSackSize state) >= maxStackSize) = True
    | otherwise = False

isUnderFlow :: VMState -> Bool
isUnderFlow state
    | (vmStackSize state) <= 1 = True
    | otherwise = False
