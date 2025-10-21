{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Types (
    Stack()
    ,SP()
    ,PC()
    ,LabelIndex()
    ,CallStack()
    ,ByteCode()
    ,Byte()
    ,VMState(..)) 
    where 

import Data.Word (Word8)
import Data.Int (Int64)

type Stack = [Word8]
type SP = Int
type PC = Int
type LabelIndex = [(Int64, Int64)]
type CallStack = [(PC, SP)]
type ByteCode = [Word8]
type Byte = Word8

data VMState = VMState
    { vmByteCode :: ByteCode
    , vmPC :: PC
    , vmStack :: Stack
    , vmSP :: SP
    , vmCallStack :: CallStack
    , vmLabels :: LabelIndex
    , vmZFlag :: Word8
    } deriving (Show)
