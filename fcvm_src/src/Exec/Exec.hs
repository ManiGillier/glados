{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module Exec.Exec (execFccByteCode) where 

import Error.MaybeError
import Error.ErrorList
import Data.Word (Word8, Word64)
import Data.Int (Int64)
import Data.Char
import Data.Bits (shiftL, (.|.))
import Debug.Trace

displayT :: [Word8]
displayT = 
    [69,12,69,12,0,0,0,0,0,0,0,10,39,0,0,0,0,0,0,0,0,0,
     39,0,0,0,0,0,0,0,1,0,89,0,0,0,0,0,0,0,10,0,89,0,0,
     0,0,0,0,0,0,0,89,0,0,0,0,0,0,0,0,0,89,0,0,0,0,0,0,
     0,42,0,30,0,0,0,0,0,0,0,0,0,29,0,0,0,0,0,0,0,0,0,
     30,0,0,0,0,0,0,0,8,0,29,0,0,0,0,0,0,0,8,0,29,0,0,
     0,0,0,0,0,0,0,13,0,30,0,0,0,0,0,0,0,16,0,29,0,0,
     0,0,0,0,0,16,0,38,0,35,0]
callFoo :: [Word8]
callFoo = 
    [69,12,69,12,0,0,0,0,0,0,0,10,39,0,0,0,0,0,0,0,0,0,
    39,0,0,0,0,0,0,0,1,0,89,0,0,0,0,0,0,0,42,0,89,0,0,
    0,0,0,0,0,30,0,30,0,0,0,0,0,0,0,0,0,29,0,0,0,0,0,0,
    0,0,0,91,0,0,0,0,0,0,0,2,0,34,0,35,0,39,0,0,0,0,0,
    0,0,2,0,89,0,0,0,0,0,0,0,12,0,89,0,0,0,0,0,0,0,0,0,
    29,255,255,255,255,255,255,255,248,0,29,0,0,0,0,0,
    0,0,0,0,13,0,30,0,0,0,0,0,0,0,8,0,29,0,0,0,0,0,0,0,
    8,0,38,0,89,0,0,0,0,0,0,0,0,0,30,255,255,255,255,255,
    255,255,248,0,35,0]

callFooBar :: [Word8]
callFooBar =
    [69,12,69,12,0,0,0,0,0,0,0,10,39,0,0,0,0,0,0,0,0,0,
    39,0,0,0,0,0,0,0,1,0,89,0,0,0,0,0,0,0,1,0,89,0,0,0,
    0,0,0,0,42,0,91,0,0,0,0,0,0,0,2,0,34,0,89,0,0,0,0,0,
    0,0,2,0,89,0,0,0,0,0,0,0,48,0,89,0,0,0,0,0,0,0,5,0,
    13,0,91,0,0,0,0,0,0,0,2,0,34,0,89,0,0,0,0,0,0,0,5,0,
    91,0,0,0,0,0,0,0,3,0,34,0,35,0,39,0,0,0,0,0,0,0,2,0,
    89,0,0,0,0,0,0,0,0,0,29,255,255,255,255,255,255,255,
    248,0,29,255,255,255,255,255,255,255,240,0,13,0,30,0,
    0,0,0,0,0,0,0,0,29,0,0,0,0,0,0,0,0,0,89,0,0,0,0,0,0,
    0,1,0,13,0,30,0,0,0,0,0,0,0,0,0,29,0,0,0,0,0,0,0,0,0,
    38,0,35,0,39,0,0,0,0,0,0,0,3,0,89,0,0,0,0,0,0,0,0,0,
    89,0,0,0,0,0,0,0,48,0,30,0,0,0,0,0,0,0,0,0,29,255,255,
    255,255,255,255,255,248,0,29,0,0,0,0,0,0,0,0,0,13,0,
    30,0,0,0,0,0,0,0,0,0,89,255,255,255,255,255,255,255,
    255,0,29,0,0,0,0,0,0,0,0,0,91,0,0,0,0,0,0,0,2,0,34,0,
    35,0]

type Stack = [Word8]
type SP = Int
type PC = Int
type LabelIndex = [(Int64, Int64)]
type CallStack = [(PC, SP)]
type ByteCode = [Word8]

-- Check file valid format
checkMagicNumber :: ByteCode -> Bool
checkMagicNumber (0x45:0xc:0x45:0xc:_) = True
checkMagicNumber _ = False

execFccByteCode :: ByteCode -> MaybeError String
execFccByteCode byteCode
    | checkMagicNumber byteCode = 
        let cleanByteCode = drop 4 byteCode
            pc = bytesToInt64 (take 8 cleanByteCode)
        in execByteCode cleanByteCode (fromIntegral pc + 8) [] 0 [] (indexLabel cleanByteCode)
    | otherwise =  Error fileFormatError $ "magic number not found"

bytesToInt64 :: [Word8] -> Int64
bytesToInt64 bytes =
    let w = foldl (\acc b -> (acc `shiftL` 8) .|. fromIntegral b) 0 bytes
    in fromIntegral (w :: Word64)

-- Convert 64-bits Integer to 8 bytes
int64To8Bytes :: Int64 -> [Word8]
int64To8Bytes n = 
    [ fromIntegral ((n `div` (256 ^ i)) `mod` 256) | i <- [7, 6..0 :: Int] ]

indexDataString :: ByteCode -> Int64 -> Int64 -> LabelIndex
indexDataString [] _ _ = []
indexDataString (0:_) _ _ = []
indexDataString (_:xs) startIndex startIndexStack =
    [(startIndex, startIndexStack)] ++ 
    indexDataString xs (startIndex + 1) (startIndexStack + 1)

dataStringLen :: ByteCode -> Int
dataStringLen [] = 0
dataStringLen (0:_) = 0
dataStringLen (_:xs) = 1 + dataStringLen xs

indexLabel :: ByteCode -> LabelIndex
indexLabel = index 0 0
  where
    index _ _ [] = []
    index i _ (39:xs) = 
        let val = bytesToInt64 (take 8 xs)
        in (i, val) : index (i + 8 + 1) (val + 1) (drop 8 xs)
    index i v (2:xs) = 
        indexDataString xs (i + 1) v ++ index (i + fromIntegral 
        (dataStringLen xs) + 1) v (drop ((dataStringLen xs)) xs)
    index i v (_:xs) = index (i + 1) v xs

pushAddrStack :: Stack -> ByteCode -> Stack
pushAddrStack st val = take 8 val ++ st

binOp :: (Int64 -> Int64 -> Int64) -> Stack -> MaybeError Stack

binOp _ [_] = Error stackError $ "underflow"
binOp _ [] = Error stackError $ "underflow"
binOp f xs = Correct $ int64To8Bytes
    (f (bytesToInt64(take 8 xs)) (bytesToInt64(take 8 $ drop 8 xs)))
    ++ drop 16 xs

dupl :: Stack -> MaybeError Stack
dupl [] = Error stackError $ "empty stack"
dupl (x:xs) = Correct (x:x:xs)

negateS :: Stack -> MaybeError Stack
negateS [] = Error stackError $ "empty stack"
negateS (x:xs) = Correct ((-x):xs)

popStack :: Stack -> Stack
popStack xs = (drop 8 xs)

-- get sublist between two index
sublist :: Int -> Int -> [a] -> [a]
sublist i j xs = take (j - i) (drop i xs)

-- Check Asm doc
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

-- Check if instruction is valid with 0 before
isInstruction :: ByteCode -> Int -> Bool
isInstruction bc pc
    | bc !! (pc - 1) == 0 = True
    | otherwise = False

-- Get programm counter to call label 
getPc :: Stack -> LabelIndex -> PC
getPc st labV = fromIntegral $ index (bytesToInt64 (take 8 st)) labV
    where
        index _ [] = 0
        index x ((y,z):xs)
            | x == z = y
            | otherwise = index x xs

-- Add new call to the Call Stack and save next instruction
-- of the current function + cur StackPtr
updateCall :: PC -> SP ->CallStack -> CallStack
updateCall pc sp cs = (pc + 1,sp) : cs

-- Return last Programm counter, last Stack Ptr and pop CallStack 
restoreStack :: CallStack -> ((PC,SP),CallStack)
restoreStack [] = ((0,0),[])
restoreStack ((pc,sp):xs) = ((pc,sp),xs)

-- skip 8bytes bytecode
skipVal :: PC -> PC
skipVal pc = pc + 9

-- Increment pc to next instruction
nextIns :: PC -> PC
nextIns pc = pc + 1

-- move 64bits
bits64 :: Int
bits64 = 8

-- Core exec function
-- TODO: refactor argument & divide func
execByteCode :: ByteCode -> PC -> Stack -> SP -> CallStack -> LabelIndex -> MaybeError String
execByteCode bc pc st sp cs lab
    -- PushValue & PushLabel & PushRelAddr
    | (bc !! pc == 89 || bc !! pc == 91) && isInstruction bc pc =
        execByteCode bc (skipVal pc) (pushAddrStack st $ drop (nextIns pc) bc) sp cs lab
    -- PopToStackPtrRel
    | bc !! pc == 30 && isInstruction bc pc =
        execByteCode bc (skipVal pc) (popToStackPtrRel st sp 
        (fromIntegral $ bytesToInt64 (take bits64 $ drop (nextIns pc) bc))) sp cs lab
    -- PushFromStackPtrRel
    | bc !! pc == 29 && isInstruction bc pc =
        execByteCode bc (skipVal pc) (pushFromStackPtrRel st sp 
        (fromIntegral $ bytesToInt64 (take bits64 $ drop (nextIns pc) bc))) sp cs lab
    -- Add
    | bc !! pc == 13 && isInstruction bc pc = 
        let res = binOp (+) st
        in case res of
             Correct nst -> execByteCode bc (nextIns pc) nst sp cs lab
             Error err msg -> Error err msg
    -- Call 
    | bc !! pc == 34 && isInstruction bc pc = 
        let newStack = popStack st
            newSP = length newStack
        in execByteCode bc (getPc st lab) 
        newStack newSP (updateCall pc sp cs) lab
    -- Ret
    | bc !! pc == 35 && isInstruction bc pc =
        let ((npc,nsp), ncs) = restoreStack cs
            in case ((npc,nsp), ncs) of
                ((0,0),[]) -> Correct $ ""
                _ -> execByteCode bc npc st nsp ncs lab
    -- Aff
    | bc !! pc == 38 && isInstruction bc pc = 
        let val = chr $ fromIntegral $ bytesToInt64 (take bits64 st)
        in case execByteCode bc (nextIns pc) (popStack st) sp cs lab of
            Correct rest -> Correct (val : rest)
            Error err msg -> Error err msg
    | otherwise =
        execByteCode bc (nextIns pc) st sp cs lab
