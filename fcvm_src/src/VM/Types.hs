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
    ,CallStack()
    ,ByteCode()
    ,Byte()
    ,Fd()
    ,IOBuffer()
    ,stdoutFd
    ,stderrFd
    ,stdinFd
    ,VMState(..)) 
    where 

import Data.Word (Word8)

type Stack = [Word8]
type SP = Int
type PC = Int
type CallStack = [(PC, SP)]
type ByteCode = [Word8]
type Byte = Word8
type Fd = Word8
type IOBuffer = [(Fd, String)]

stdinFd, stdoutFd, stderrFd :: Fd
stdinFd  = 0
stdoutFd = 1
stderrFd = 2

data VMState = VMState
    { vmByteCode :: ByteCode
    , vmPC :: PC
    , vmStack :: Stack
    , vmSP :: SP
    , vmCallStack :: CallStack
    , vmZFlag :: Word8
    , vmIO :: IOBuffer
    , vmEnd :: Bool
    , vmDebug :: Bool
    }

instance Show VMState where
    show s = unlines
        [ "=== VM State ==="
        , "PC: " ++ show (vmPC s)
        , "SP: " ++ show (vmSP s)
        , "ZFlag: " ++ show (vmZFlag s)
        , "End: " ++ show (vmEnd s)
        , "Debug: " ++ show (vmDebug s)
        , "Stack: " ++ show (vmStack s)
        , "CallStack: " ++ show (vmCallStack s)
        , "IO Buffer: " ++ show (vmIO s)
        , "ByteCode (len=" ++ show (length (vmByteCode s)) ++ ")"
        , "ByteCode:" ++ show (vmByteCode s)
        ]
