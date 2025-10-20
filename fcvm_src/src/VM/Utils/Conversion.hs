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
    ,nextIns
    ,skipVal
    ,bits64)
    where 

import Data.Word (Word8, Word64)
import VM.Types
import Data.Int (Int64)
import Data.Bits (shiftL, (.|.))

bytesToInt64 :: [Word8] -> Int64
bytesToInt64 bytes =
    let w = foldl (\acc b -> (acc `shiftL` 8) .|. fromIntegral b) 0 bytes
    in fromIntegral (w :: Word64)

int64To8Bytes :: Int64 -> [Word8]
int64To8Bytes n = 
    [ fromIntegral ((n `div` (256 ^ i)) `mod` 256) | i <- [7, 6..0 :: Int] ]

sublist :: Int -> Int -> [a] -> [a]
sublist i j xs = take (j - i) (drop i xs)

nextIns :: PC -> PC
nextIns pc = pc + 1

skipVal :: PC -> PC
skipVal pc = pc + 9

bits64 :: Int
bits64 = 8
