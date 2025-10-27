{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Executor ( execFccByteCode, execAllByteCodes
                   , printVMIO
                   ) where

import Data.Word
import Error.ErrorList
import VM.Types
import VM.Instructions.Arithmetic
import VM.Instructions.Comparator
import VM.Instructions.Unary
import VM.Instructions.IO
import VM.Instructions.Control
import VM.Instructions.Stack
import VM.ByteCode
import Data.Bits
import Debug.Trace
import System.IO (hPutStr, hFlush)
import System.Exit

dispatchInstructions :: Byte -> VMState -> VMState
dispatchInstructions 89 s = handlePushValue s
dispatchInstructions 91 s = handlePushValue s
dispatchInstructions 30 s = handlePopToStackPtrRel s
dispatchInstructions 31 s = handlePopEmpty s
dispatchInstructions 29 s = handlePushFromStackPtrRel s
dispatchInstructions 13 state = handleOp (+) state True
dispatchInstructions 14 state = handleOp (-) state True
dispatchInstructions 15 state = handleOp (*) state True
dispatchInstructions 16 state = handleOp Prelude.div state False
dispatchInstructions 17 state = handleOp Prelude.mod state False
dispatchInstructions 6 state = handleOp ((.&.)) state False
dispatchInstructions 7 state = handleOp ((.|.)) state False
dispatchInstructions 10 state = handleOp (xor) state False
dispatchInstructions 11 state = handleBitshift (shiftL) state
dispatchInstructions 12 state = handleBitshift (shiftR) state
dispatchInstructions 8 state = handleBoolComp (&&) state
dispatchInstructions 9 state = handleBoolComp (||) state
dispatchInstructions 18 state = handleComp (>) state
dispatchInstructions 19 state = handleComp (>=) state
dispatchInstructions 20 state = handleComp (<) state
dispatchInstructions 21 state = handleComp (<=) state
dispatchInstructions 22 state = handleComp (==) state
dispatchInstructions 23 state = handleComp (/=) state
dispatchInstructions 3 state = handleBinNot state
dispatchInstructions 4 state = handleNot state
dispatchInstructions 5 state = handleNegate state
dispatchInstructions 34 state = handleCall state
dispatchInstructions 35 state = handleRet state
dispatchInstructions 24 state = handleZflag state
dispatchInstructions 36 state = handleJmp state
dispatchInstructions 37 state = handleZjmp state
dispatchInstructions 38 state = handleAff state
dispatchInstructions 39 state = handleAffs state
dispatchInstructions _ state = state { vmPC = nextIns (vmPC state) }

isEnd :: VMState -> Bool
isEnd state =
    let end = (vmEnd state)
    in end

execByteCode :: VMState -> VMState
execByteCode state
    | isEnd state   = state
    | vmDebug state = traceShow state $ nextState
    | otherwise     = nextState
  where
    opcode = vmByteCode state !! vmPC state
    nextState = dispatchInstructions opcode $ state { vmIO = [] }

execAllByteCodes :: VMState -> [VMState]
execAllByteCodes state = Prelude.takeWhile (not . isEnd)
  $ iterate execByteCode state

initVmState :: [Word8] -> VMState
initVmState byteCode = 
    VMState (drop 4 byteCode) 8 (replicate 8 0)
        8 [] 1 [] False Nothing False

printWFlush :: Fd -> String -> IO ()
printWFlush file content = hPutStr file content >> hFlush file

printSingleVMIO :: (Fd, String) -> IO ()
printSingleVMIO (file, content)
    | file == stderrFd = printWFlush file ("\n" ++ content ++ "\n") 
        >> exitWith (ExitFailure 84)
    | otherwise = printWFlush file content

printVMIO :: [VMState] -> IO ()
printVMIO states = mapM_ (\state -> mapM_ printSingleVMIO $ vmIO state) states

execFccByteCode :: [Word8] -> VMState
execFccByteCode byteCode
    | checkMagicNumber byteCode = initVmState byteCode
    | otherwise = (initVmState byteCode)
        { vmIO = [(stderrFd, fileFormatError)] }
