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
import Data.Bits (shiftL, (.|.), shiftR, (.&.))
import Debug.Trace

displayT :: [Word8]
displayT = 
    [69,12,69,12,39,0,0,0,0,0,0,0,0,0,39,0,0,0,0,0,0,0,1,0,
    89,0,0,0,0,0,0,0,10,0,89,0,0,0,0,0,0,0,0,0,89,0,0,0,0,0,0,0,0,0,
    89,0,0,0,0,0,0,0,42,0,30,0,0,0,0,0,0,0,0,0,29,0,0,0,0,0,0,0,0,0,
    30,0,0,0,0,0,0,0,8,0,29,0,0,0,0,0,0,0,8,0,29,0,0,0,0,0,0,0,0,0,
    13,0,30,0,0,0,0,0,0,0,16,0,29,0,0,0,0,0,0,0,16,0,38,0,35,0]

callFoo :: [Word8]
callFoo = 
    [69,12,69,12,39,0,0,0,0,0,0,0,0,0,39,0,0,0,0,0,0,0,1,0,
    89,0,0,0,0,0,0,0,42,0,89,0,0,0,0,0,0,0,30,0,
    30,0,0,0,0,0,0,0,0,0,29,0,0,0,0,0,0,0,0,0,91,0,0,0,0,0,0,0,2,0,
    34,0,35,0,39,0,0,0,0,0,0,0,2,0,89,0,0,0,0,0,0,0,12,0,
    89,0,0,0,0,0,0,0,0,0,29,255,255,255,255,255,255,255,248,0,
    29,0,0,0,0,0,0,0,0,0,13,0,30,0,0,0,0,0,0,0,8,0,29,0,0,0,0,0,0,0,8,0,
    38,0,89,0,0,0,0,0,0,0,0,0,30,255,255,255,255,255,255,255,248,0,35,0]

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

getPc :: Stack -> LabelIndex -> PC
getPc st labV = fromIntegral $ index (bytesToInt64 (take 8 st)) labV
    where
        index _ [] = 0
        index x ((y,z):xs)
            | x == z = y
            | otherwise = index x xs

execByteCode :: ByteCode -> PC -> Stack -> SP -> LabelIndex -> MaybeError String
execByteCode bc pc st sp lab
    -- End execution
    | pc >= length bc = Correct $ ""
    -- PushValue & PushLabel & PushRelAddr
    | bc !! pc == 89 || bc !! pc == 91 && isInstruction bc pc =
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
    -- Call 
    | bc !! pc == 34 && isInstruction bc pc = 
         execByteCode bc (getPc st lab) (popStack st) ((length st) - 8) lab
    -- Aff
    | bc !! pc == 38 && isInstruction bc pc = 
        let val = chr $ fromIntegral $ bytesToInt64 (take 8 st)
        in case execByteCode bc (pc + 1) (popStack st) sp lab of
            Correct rest -> Correct (val : rest)
            Error err msg -> Error err msg
    | otherwise =
        traceShow ("st=", st)
        execByteCode bc (pc + 1) st sp lab
