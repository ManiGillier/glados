{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Labels (indexDataString, dataStringLen,indexLabel, getPc) where 

import VM.Types
import VM.Utils.Conversion
import Data.Int (Int64)

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

getPc :: Stack -> LabelIndex -> PC
getPc st labV = fromIntegral $ index (bytesToInt64 (take 8 st)) labV
    where
        index _ [] = 0
        index x ((y,z):xs)
            | x == z = y
            | otherwise = index x xs
