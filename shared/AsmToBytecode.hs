{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Asm
-}

module ByteCode.AsmToBytecode (
        asmToBytecode
        ,setAddrLabel
        ) where

import DataStruct.Asm
import Data.Int (Int64)
import Data.Word (Word8)
import Data.List (isPrefixOf, tails, findIndex)
import Data.Char

instructionSize :: Instruction -> Int
instructionSize (PushValue _) = 1 + 8
instructionSize (PushRelAddr _) = 1 + 8
instructionSize (PushLabel _) = 1 + 8
instructionSize (PushFromStackPtrRel _) = 1 + 8
instructionSize (PopToStackPtrRel _) = 1 + 8
instructionSize (Label _) = 0
instructionSize (Affs str) = 1 + 8 + length str
instructionSize _ = 1

setAddrLabel :: [Instruction] -> Int64 -> [(String, Int64)]
setAddrLabel [] _ = []
setAddrLabel (inst:xs) offset =
    case inst of
        Label labelName -> (labelName, offset) :
            setAddrLabel xs (offset + fromIntegral (instructionSize inst))
        _ -> setAddrLabel xs (offset + fromIntegral (instructionSize inst))

getAddressLabel :: String -> [(String, Int64)] -> Int64
getAddressLabel _ [] = (-1)
getAddressLabel name ((x, y):xs)
    | name == x = y
    | otherwise = getAddressLabel name xs

-- Convert 64-bits Integer to 8 bytes
intTo8Bytes :: Integral a => a -> [Word8]
intTo8Bytes n =
    [ fromIntegral ((n `div` (256 ^ i)) `mod` 256) | i <- [7, 6..0 :: Int] ]

stringWord8 :: String -> [Word8]
stringWord8 str = map (fromIntegral . ord) str

startingPoint :: [Word8]
startingPoint = [39,0,0,0,0,0,0,0,1,0]

getStartingPoint :: [Word8] -> Int
getStartingPoint xs =
  case findIndex (isPrefixOf startingPoint) (tails xs) of
    Just i  -> i
    Nothing -> -1

instructionToByteCode :: [(String, Int64)] -> Instruction -> [Word8]
instructionToByteCode _ (BinNot) = [3]
instructionToByteCode _ (BoolNot) = [4]
instructionToByteCode _ (Negate) = [5]
instructionToByteCode _ (BinAnd) = [6]
instructionToByteCode _ (BinOr) = [7]
instructionToByteCode _ (BoolAnd) = [8]
instructionToByteCode _ (BoolOr) = [9]
instructionToByteCode _ (Xor) = [10]
instructionToByteCode _ (BitShiftLeft) = [11]
instructionToByteCode _ (BitShiftRight) = [12]
instructionToByteCode _ (Add) = [13]
instructionToByteCode _ (Sub) = [14]
instructionToByteCode _ (Mult) = [15]
instructionToByteCode _ (Div) = [16]
instructionToByteCode _ (Mod) = [17]
instructionToByteCode _ (Gt ) = [18]
instructionToByteCode _ (Ge ) = [19]
instructionToByteCode _ (Lt ) = [20]
instructionToByteCode _ (Le ) = [21]
instructionToByteCode _ (Eq) = [22]
instructionToByteCode _ (Diff) = [23]
instructionToByteCode _ (UpdateZFlag) = [24]
instructionToByteCode _ (PushValue addr) = [89] ++ intTo8Bytes addr
instructionToByteCode _ (PushRelAddr addr) = [91] ++ intTo8Bytes addr
instructionToByteCode labAddrs (PushLabel labName) = [91]
    ++ intTo8Bytes (getAddressLabel labName labAddrs)
instructionToByteCode _ (PushFromStackPtrRel addr) = [29] ++ intTo8Bytes addr
instructionToByteCode _ (PopToStackPtrRel addr) = [30] ++ intTo8Bytes addr
instructionToByteCode _ (PopEmpty) = [31]
instructionToByteCode _ (Call) = [34]
instructionToByteCode _ (Ret) = [35]
instructionToByteCode _ (Jmp) = [36]
instructionToByteCode _ (Zjmp) = [37]
instructionToByteCode _ (Aff) = [38]
instructionToByteCode _ (Affs str) = [39] ++ intTo8Bytes (length str)
  ++ stringWord8 str
instructionToByteCode _ _ = []

-- Magic number definition
magicNumber :: [Word8]
magicNumber = [0x45, 0xc, 0x45, 0xc]

-- list of instructions and return magic number + list of byte
asmToBytecode :: [Instruction] -> [Word8]
asmToBytecode insTructions =
    let labelAddr = setAddrLabel insTructions 8
        byteCode = concatMap (instructionToByteCode labelAddr) insTructions
    in magicNumber
        ++ (intTo8Bytes $ (fromIntegral $ getStartingPoint byteCode :: Int64))
        ++ byteCode
