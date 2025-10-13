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

testByteCode :: [Word8]
testByteCode = 
    [69,12,69,12,39,0,0,0,0,0,0,0,0,0,39,0,0,0,0,0,0,0,1,0,
    2,72,101,108,108,111,44,32,87,111,114,108,100,33,0,39,0,0,0,0,0,0,0,15,0,
    39,0,0,0,0,0,0,0,16,0,91,0,0,0,0,0,0,0,15,91,0,0,0,0,0,0,0,1,14,0,
    39,0,0,0,0,0,0,0,17,0,33,0,91,0,0,0,0,0,0,0,18,37,0,33,0,5,0,
    91,0,0,0,0,0,0,0,15,13,0,38,0,89,0,0,0,0,0,0,0,1,14,0,91,0,0,0,0,0,0,0,17,36,0,
    39,0,0,0,0,0,0,0,18,0]

type Stack = [(Int64, Int64)]

type LabelIndex = [(Int64, Int64)]

checkMagicNumber :: [Word8] -> Bool
checkMagicNumber (0x45:0xc:0x45:0xc:_) = True
checkMagicNumber _ = False

execFccByteCode :: [Word8] -> MaybeError String
execFccByteCode byteCode
    | checkMagicNumber byteCode = execByteCode [] (indexLabel $ drop 4 byteCode) $ drop 4 byteCode
    | otherwise =  Error fileFormatError $ "magic number not found"

bytesToInt64 :: [Word8] -> Int64
bytesToInt64 = fromIntegral . sum

indexDataString :: [Word8] -> Int64 -> Int64 -> LabelIndex
indexDataString [] _ _ = []
indexDataString (0:_) _ _ = []
indexDataString (_:xs) startIndex startIndexStack =
    [(startIndex, startIndexStack)] ++ 
    indexDataString xs (startIndex + 1) (startIndexStack + 1)

dataStringLen :: [Word8] -> Int
dataStringLen [] = 0
dataStringLen (0:_) = 0
dataStringLen (_:xs) = 1 + dataStringLen xs

indexLabel :: [Word8] -> LabelIndex
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

execByteCode :: Stack -> LabelIndex -> [Word8] -> MaybeError String
execByteCode _ _ _ = Correct "test"
