{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Executor ( execFccByteCode, execAllByteCodes,
                     execByteCode
                   , printVMIO
                   ) where

import Data.Word
import Error.ErrorList
import VM.Types
import VM.Stack
import VM.ByteCode
import VM.Dispatch
import Debug.Trace
import System.IO (hPutStr, hFlush)
import System.Exit
import Data.Int (Int64)
import Data.Maybe (isJust)

isEnd :: VMState -> Bool
isEnd state =
    let end = (vmEnd state)
    in end

execByteCode :: VMState -> VMState
execByteCode state
    | isEnd state   = state
    | isJust $ vmRetVal state = state { vmEnd = True }
    | vmDebug state = traceShow state $ nextState
    | isStackOverFlow state = 
         state { vmIO = [(stderrFd, stackOverFlowError)]}
    | otherwise     = nextState
  where
    opcode = vmByteCode state !! vmPC state
    nextState = dispatchInstructions opcode $ state { vmIO = [] }

execAllByteCodes :: VMState -> [VMState]
execAllByteCodes state = Prelude.takeWhile (not . isEnd)
  $ iterate execByteCode state

initVmState :: [Word8] -> VMState
initVmState byteCode = 
    VMState (drop 4 byteCode) 8 (replicate 8 0) 1 0
        8 [] 1 [] False Nothing False

printWFlush :: Fd -> String -> IO ()
printWFlush file content = hPutStr file content >> hFlush file

printSingleVMIO :: (Fd, String) -> IO ()
printSingleVMIO (file, content)
    | file == stderrFd = printWFlush file ("\n" ++ content ++ "\n")
        >> exitWith (ExitFailure 84)
    | otherwise = printWFlush file content

exitIfFinished :: Maybe Int64 -> IO ()
exitIfFinished (Just x) = exitWith $ case fromEnum x of
  0 -> ExitSuccess
  x' -> ExitFailure (x' `mod` 256)
exitIfFinished Nothing = return ()

printVMIO :: [VMState] -> IO ()
printVMIO states = mapM_
  (\state -> (mapM_ printSingleVMIO $ vmIO state)
    >> (exitIfFinished $ vmRetVal state)) states

execFccByteCode :: [Word8] -> VMState
execFccByteCode byteCode
    | checkMagicNumber byteCode = initVmState byteCode
    | otherwise = (initVmState byteCode)
        { vmIO = [(stderrFd, fileFormatError)] }
