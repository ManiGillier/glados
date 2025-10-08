{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Asm
-}

module ByteCode.AsmToBytecode (displayInstruction
                               , asmToBytecode
                               , setAddressToLabel
                               ) where
import DataStruct.Asm
import Data.Word (Word8)
import Data.Char (ord)
import Data.Int (Int64)

displayInstruction :: Instruction -> String
displayInstruction = show

setAddressToLabel :: [Instruction] -> Int64 -> [(String, Int64)]
setAddressToLabel [] _ = []
setAddressToLabel ((Label labelName):xs) n =
     [(labelName, n)] ++ setAddressToLabel xs (n + 1)
setAddressToLabel (_:xs) n = setAddressToLabel xs n

getAddressLabel :: String -> [(String, Int64)] -> Int64
getAddressLabel _ [] = (-1) 
getAddressLabel name ((x, y):xs)
    | name == x = y
    | otherwise = getAddressLabel name xs

instructionEnd :: [Word8]
instructionEnd = [0x0]

-- Convert 64-bits Integer to 8 bytes
intTo8Bytes :: Int64 -> [Word8]
intTo8Bytes n = 
    [ fromIntegral ((n `div` (256 ^ i)) `mod` 256) | i <- [7, 6..0 :: Int] ]

stringWord8 :: String -> [Word8]
stringWord8 str = map (fromIntegral . ord) str

instructionToByteCode :: [(String, Int64)] -> Instruction -> [Word8]
instructionToByteCode _ (DataInt val) = 
    [1] ++ intTo8Bytes val
instructionToByteCode _ (DataString str) = 
    [2] ++ stringWord8 str ++ instructionEnd
instructionToByteCode _ (BinNot) = 
    [3] ++ instructionEnd
instructionToByteCode _ (BoolNot) = [4] ++ instructionEnd
instructionToByteCode _ (Negate) = [5] ++ instructionEnd
instructionToByteCode _ (BinAnd) = [6] ++ instructionEnd
instructionToByteCode _ (BinOr) = [7] ++ instructionEnd
instructionToByteCode _ (BoolAnd) = [8] ++ instructionEnd
instructionToByteCode _ (BoolOr) = [9] ++ instructionEnd
instructionToByteCode _ (Xor) = [10] ++ instructionEnd
instructionToByteCode _ (BitShiftLeft) = [11] ++ instructionEnd
instructionToByteCode _ (BitShiftRight) = [12] ++ instructionEnd
instructionToByteCode _ (Add) = [13] ++ instructionEnd
instructionToByteCode _ (Sub) = [14] ++ instructionEnd
instructionToByteCode _ (Mult) = [15] ++ instructionEnd
instructionToByteCode _ (Div) = [16] ++ instructionEnd
instructionToByteCode _ (Mod) = [17] ++ instructionEnd
instructionToByteCode _ (Gt ) = [18] ++ instructionEnd
instructionToByteCode _ (Ge ) = [19] ++ instructionEnd
instructionToByteCode _ (Lt ) = [20] ++ instructionEnd
instructionToByteCode _ (Le ) = [21] ++ instructionEnd
instructionToByteCode _ (Eq) = [22] ++ instructionEnd
instructionToByteCode _ (Diff) = [23] ++ instructionEnd
instructionToByteCode _ (Is) = [24] ++ instructionEnd
instructionToByteCode _ (PushValue addr) = [89] ++ intTo8Bytes addr
instructionToByteCode _ (PushGlobAddr addr) = [90] ++ intTo8Bytes addr
instructionToByteCode _ (PushRelAddr addr) = [91] ++ intTo8Bytes addr
instructionToByteCode labAddrs (PushLabel labName) =
    [91] ++ intTo8Bytes (getAddressLabel labName labAddrs)
instructionToByteCode _ (PushFromStackPtrRel addr) = [29] ++ intTo8Bytes addr
instructionToByteCode _ (PopToStackPtrRel addr) = [30] ++ intTo8Bytes addr
instructionToByteCode _ (PopEmpty) = [31] ++ instructionEnd
instructionToByteCode _ (WriteToStackPtrRel addr val) =
    [96] ++ intTo8Bytes addr ++ intTo8Bytes val
instructionToByteCode _ (Dupl) = [33] ++ instructionEnd
instructionToByteCode _ (Call) = [34] ++ instructionEnd
instructionToByteCode _ (Ret) = [35] ++ instructionEnd
instructionToByteCode _ (Jmp) = [36] ++ instructionEnd
instructionToByteCode _ (Zjmp) = [37] ++ instructionEnd
instructionToByteCode _ (Aff) = [38] ++ instructionEnd
instructionToByteCode _ _ = []

-- Magic number definition
magicNumber :: [Word8]
magicNumber = [0x45, 0xc, 0x45, 0xc]

-- Take list of (key,value) label name & address,
-- list of instructions and return magic number + list of byte
asmToBytecode :: [(String, Int64)] -> [Instruction] -> [Word8]
asmToBytecode labelAddr xs =
    magicNumber ++ 
    concatMap (instructionToByteCode labelAddr) xs
