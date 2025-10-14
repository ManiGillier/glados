{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module Exec.Exec (execFccByteCode) where 

import Error.MaybeError
import Error.ErrorList
import Data.Word (Word8)
import Data.Int (Int64)
import Data.Char
import Debug.Trace

testByteCode :: [Word8]
testByteCode = 
    [69,12,69,12,39,0,0,0,0,0,0,0,0,0,39,0,0,0,0,0,0,0,1,0,
    89,0,0,0,0,0,0,0,10,0,89,0,0,0,0,0,0,0,0,0,89,0,0,0,0,0,0,0,0,0,
    89,0,0,0,0,0,0,0,42,0,30,0,0,0,0,0,0,0,0,0,29,0,0,0,0,0,0,0,0,0,
    30,0,0,0,0,0,0,0,8,0,29,0,0,0,0,0,0,0,8,0,29,0,0,0,0,0,0,0,0,0,
    13,0,30,0,0,0,0,0,0,0,16,0,29,0,0,0,0,0,0,0,16,0,38,0,35,0]

type Stack = [Word8]
type SP = Int
type PC = Int
type LabelIndex = [(Int64, Int64)]
type ByteCode = [Word8]

-- Check file valid format
checkMagicNumber :: ByteCode -> Bool
checkMagicNumber (0x45:0xc:0x45:0xc:_) = True
checkMagicNumber _ = False

execFccByteCode :: ByteCode -> MaybeError String
execFccByteCode byteCode
    | checkMagicNumber byteCode = 
        let cleanByteCode = drop 4 byteCode
        in execByteCode cleanByteCode 0 [] 0 (indexLabel cleanByteCode)
    | otherwise =  Error fileFormatError $ "magic number not found"

bytesToInt64 :: ByteCode -> Int64
bytesToInt64 = fromIntegral . sum

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
        let len = dataStringLen xs
        in indexDataString xs (i + 1) v ++ 
        index (i + fromIntegral len + 1) v (drop (len) xs)
    index i v (_:xs) = index (i + 1) v xs

pushAddrStack :: Stack -> ByteCode -> Stack
pushAddrStack st val = st ++ take 8 val

binOp :: (Int64 -> Int64 -> Int64) -> Stack -> MaybeError Stack
binOp _ [_] = Error stackError $ "underflow"
binOp _ [] = Error stackError $ "underflow"
binOp f xs = Correct $ int64To8Bytes
    (f (bytesToInt64(take 8 xs)) (bytesToInt64(take 8 $ drop 8 xs)))

dupl :: Stack -> MaybeError Stack
dupl [] = Error stackError $ "empty stack"
dupl (x:xs) = Correct (x:x:xs)

negateS :: Stack -> MaybeError Stack
negateS [] = Error stackError $ "empty stack"
negateS (x:xs) = Correct ((-x):xs)

write :: Stack -> Stack
write xs = traceShow ("x", xs) xs

popStack :: Stack -> Stack
popStack xs = (drop 8 xs)

popToStackPtrRel :: Stack -> SP -> Int -> Stack
popToStackPtrRel st sp addr = 
    let size = length st
    in (take (addr + sp)  st) ++ (drop (size - 8) st) ++ 
        (drop (addr + 8 + sp) (take (size - 8) st))

pushFromStackPtrRel :: Stack -> SP -> Int -> Stack
pushFromStackPtrRel st sp addr = 
    let val = take 8 $ drop (addr + sp) st
    in st ++ val

isInstruction :: ByteCode -> Int -> Bool
isInstruction bc pc
    | bc !! (pc - 1) == 0 = True
    | otherwise = False

execByteCode :: ByteCode -> PC -> Stack -> SP -> LabelIndex -> MaybeError String
execByteCode bc pc st sp lab
    | pc >= length bc = Correct $ ""
    -- PushValue
    | bc !! pc == 89 && isInstruction bc pc =
        execByteCode bc (pc + 8) (pushAddrStack st $ drop (pc + 1) bc) sp lab
    -- PopToStackPtrRel
    | bc !! pc == 30 && isInstruction bc pc =
        execByteCode bc (pc + 8) (popToStackPtrRel st sp 
        (fromIntegral $ bytesToInt64 (take 8 $ drop (pc + 1) bc))) sp lab
    -- PushFromStackPtrRel
    | bc !! pc == 29 && isInstruction bc pc =
        execByteCode bc (pc + 8) (pushFromStackPtrRel st sp 
        (fromIntegral $ bytesToInt64 (take 8 $ drop (pc + 1) bc))) sp lab
    -- Add
    | bc !! pc == 13 && isInstruction bc pc = 
        let res = binOp (+) st
        in case res of
             Correct nst -> execByteCode bc (pc + 8) nst sp lab
             Error err msg -> Error err msg
    -- Aff
    | bc !! pc == 38 && isInstruction bc pc = 
        let val = chr $ fromIntegral $ bytesToInt64 (take 8 st)
        in case execByteCode bc (pc + 1) (popStack st) sp lab of
            Correct rest -> Correct (val : rest)
            Error err msg -> Error err msg
    | otherwise =
        execByteCode bc (pc + 1) st sp lab
