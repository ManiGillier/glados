{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Utils.Conversion (
     bytesToInt64
    ,int64To8Bytes
    ,sublist
    ,bits64
    ,boolToInt64
    ,int64ToBool)
    where 

import Data.Word (Word8, Word64)
import Data.Int (Int64)
import Data.Bits (shiftL, (.|.))

bytesToInt64 :: [Word8] -> Int64
bytesToInt64 bytes =
    let w = foldl (\acc b -> (acc `shiftL` 8) .|. fromIntegral b) 0 bytes
    in fromIntegral (w :: Word64)

int64To8Bytes :: Int64 -> [Word8]
int64To8Bytes n = 
    [ fromIntegral ((n `div` (256 ^ i)) `mod` 256) | i <- [7, 6..0 :: Int] ]

boolToInt64 :: Bool -> Int64
boolToInt64 True = 1
boolToInt64 _ = 0

int64ToBool :: Int64 -> Bool
int64ToBool x
    | x > 0 = True
    | otherwise = False

sublist :: Int -> Int -> [a] -> [a]
sublist i j xs = take (j - i) (drop i xs)


bits64 :: Int
bits64 = 8
