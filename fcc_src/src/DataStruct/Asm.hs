{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Asm
-}

module DataStruct.Asm (Asm
                      , Instruction (..)
                      , Value (..)
                      , LabelName
                      , VariableName
                      , Addr
                      ) where

import Data.Word (Word8)
import Data.Char (ord)
import Data.Int (Int64)

type LabelName = String
type VariableName = String

type Addr = Int64

data Value =
  StackPos !Int
  | GlobalPos !Int
  | RelativePos !Int
  | LabelPos !LabelName
  | Variable !VariableName
  deriving (Show)

data Instruction =
  -- Label definition (bin output = [])
  Label !LabelName
  -- Unary
  | DataInt !Int64
  | DataString !String
  | BinNot
  | BoolNot
  | Negate
  -- Binary
  | BinAnd
  | BinOr
  | BoolAnd
  | BoolOr
  | Xor
  | BitShiftLeft
  | BitShiftRight
  | Add
  | Sub
  | Mult
  | Div
  | Mod
  | Gt -- Greater
  | Ge -- Greater or equal
  | Lt -- Less
  | Le -- Less or equal
  | Eq
  | Diff
  | Is
  | UpdateZFlag -- Pops stack, if zero set z flag to 1 else 0
  -- Push (Push 4 byte to the stack)
  | PushValue !Int64
  | PushGlobAddr !Int64
  | PushRelAddr !Int64
  | PushLabel !LabelName -- Same bytecode as PushRelAddr
  | PushFromStackPtrRel !Addr -- Push the value stored here
  -- Pop (Pop 4 bytes from the stack)
  | PopToStackPtrRel !Addr -- Pop and set to the address :D
  | PopEmpty
  -- Stack writing
  | WriteToStackPtrRel !Addr !Int64 -- Write Int to stack ptr + Addr
  -- Both
  | Dupl -- Duplicates last stack entry
  -- Function (modified stack)
  | Call -- Remember stack pointer :D
  | Ret -- Retrieve caller stack pointer :D
  -- Jumps (POPS addr from stack)
  | Jmp
  | Zjmp -- Pops test from stack (if == 0, jump else continue)
  -- Debug functions (to remove later)
  | Aff -- Shows single char from addr popped from stack
  deriving (Show)

-- Addr is the address added to the address of the stack pointer !

type Asm = [Instruction]

displayInstruction :: Instruction -> String
displayInstruction = show

setAddressToLabel :: [Instruction] -> Int64 -> [(String, Int64)]
setAddressToLabel [] _ = []
setAddressToLabel ((Label labelName):xs) n =
     [(labelName, n)] ++ setAddressToLabel xs (n + 1)
setAddressToLabel (_:xs) n = setAddressToLabel xs n

getAddressLabel :: String -> [(String, Int64)] -> Int64
-- TODO: Error here label not found
getAddressLabel _ [] = (-1) 
getAddressLabel name ((x, y):xs)
    | name == x = y
    | otherwise = getAddressLabel name xs

instructionEnd :: [Word8]
instructionEnd = [0x0]

intTo8Bytes :: Int64 -> [Word8]
intTo8Bytes n = [ fromIntegral ((n `div` (256 ^ i)) `mod` 256) | i <- [7,6..0] ]

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
    [28] ++ intTo8Bytes (getAddressLabel labName labAddrs)
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

-- Take list of (key,value) label name & address,
-- list of instructions and return magic number + list of byte
asmToBytecode :: [(String, Int64)] -> [Instruction] -> [Word8]
asmToBytecode labelAddr xs =
    [0x45, 0xc, 0x45, 0xc] ++ 
    concatMap (instructionToByteCode labelAddr) xs

test :: [Instruction]
test = [
    Label ".data"
  , Label ".str_HelloWorld"
  , DataInt 32
  , DataString "Hello, World!"
  , Label ".str_HelloWorld_end"
  , Label ".start"
  , PushLabel ".str_HelloWorld_end"
  , PushLabel ".str_HelloWorld"
  , Sub -- Len of string #0 +1 ~1
  , Label ".loop"
  , Dupl -- #1 +1 ~2
  , PushLabel ".end" -- #2 +1 ~3
  , Zjmp -- -2 ~1
  , Dupl -- #1 + 1 -- len ~2
  , Negate -- +0 -- -len ~2
  , PushLabel ".str_HelloWorld_end" -- #2 +1 ~3
  , Add -- -1 -- .str_HelloWorld_end - len #1 ~2
  , Aff -- Show "Hello, World!"[actual_len - len] -1 ~1
  , PushValue 1 -- #1 +1 ~2
  , Sub -- #0 -1 (new len = len - 1) ~1
  , PushLabel ".loop"
  , Jmp
  , Label ".end"
  ]
