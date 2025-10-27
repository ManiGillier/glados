{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Types (
     Stack()
    ,StackSize()
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

import System.IO (Handle, stdout, stdin, stderr)
import Data.Word (Word8)
import Data.Int (Int64)

type Stack = [Word8]
type StackSize = Int64
type SP = Int
type PC = Int
type CallStack = [(PC, SP)]
type ByteCode = [Word8]
type Byte = Word8
type Fd = Handle
type IOBuffer = [(Fd, String)]

stdinFd :: Fd
stdoutFd :: Fd
stderrFd :: Fd
stdinFd  = stdin
stdoutFd = stdout
stderrFd = stderr

data VMState = VMState
    { vmByteCode :: ByteCode
    , vmPC :: PC
    , vmStack :: Stack
    , vmSackSize :: StackSize
    , vmCallSackSize :: StackSize
    , vmSP :: SP
    , vmCallStack :: CallStack
    , vmZFlag :: Word8
    , vmIO :: IOBuffer
    , vmEnd :: Bool
    , vmRetVal :: Maybe Int64
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
        , "Return Value: " ++ show (vmRetVal s)
        , "Stack size: " ++ show (vmSackSize s)
        , "Call stack size: " ++ show (vmCallSackSize s)
        , "ByteCode (len=" ++ show (length (vmByteCode s)) ++ ")"
        , "ByteCode:" ++ show (vmByteCode s)
        ]
