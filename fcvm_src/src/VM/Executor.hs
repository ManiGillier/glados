{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.Executor (execFccByteCode) where 

import Data.Word
import Error.MaybeError
import Error.ErrorList
import VM.Types
import VM.Instructions.Arithmetic
import VM.Instructions.IO
import VM.Instructions.Control
import VM.Instructions.Stack
import VM.Utils.Conversion
import VM.ByteCode
import VM.Labels 
import VM.Utils.Debug
import Debug.Trace

dispatchInstruction :: Byte -> VMState -> MaybeError String
dispatchInstruction opcode state = dispatchStackInstruction opcode state

dispatchStackInstruction :: Byte -> VMState -> MaybeError String
dispatchStackInstruction 89 s = execByteCode $ handlePushValue s
dispatchStackInstruction 91 s = execByteCode $ handlePushValue s
dispatchStackInstruction 30 s = execByteCode $ handlePopToStackPtrRel s
dispatchStackInstruction 29 s = execByteCode $ handlePushFromStackPtrRel s
dispatchStackInstruction op state = dispatchArithmeticinstruction op state

dispatchArithmeticinstruction :: Byte -> VMState -> MaybeError String
dispatchArithmeticinstruction 13 state =
    case handleAdd state of
        Correct newState -> execByteCode newState
        Error err msg    -> Error err msg
dispatchArithmeticinstruction op state = dispatchControlInstruction op state

dispatchControlInstruction :: Byte -> VMState -> MaybeError String
dispatchControlInstruction 34 state = execByteCode $ handleCall state
dispatchControlInstruction 35 state = 
    case handleRet state of
        Nothing      -> Correct ""
        Just newState -> execByteCode newState
dispatchControlInstruction op state = dispatchIoInstruction op state

dispatchIoInstruction :: Byte -> VMState -> MaybeError String
dispatchIoInstruction 38 state = let (char, newState) = handleAff state
      in case execByteCode newState of
            Correct rest -> Correct (char : rest)
            Error err msg -> Error err msg
dispatchIoInstruction _ state = 
    execByteCode $ state { vmPC = nextIns (vmPC state) }

execByteCode :: VMState -> MaybeError String
execByteCode state
    | isInstruction (vmByteCode state) (vmPC state) = 
        let opcode = vmByteCode state !! vmPC state
        in dispatchInstruction opcode state
    | otherwise = 
        execByteCode $ state { vmPC = nextIns (vmPC state) }

execFccByteCode :: [Word8] -> MaybeError String
execFccByteCode byteCode
    | checkMagicNumber byteCode = 
        let cleanByteCode = drop 4 byteCode
            pc = bytesToInt64 (take 8 cleanByteCode)
            state = VMState cleanByteCode (fromIntegral pc + 8)
                [] 0 [] (indexLabel cleanByteCode)
        in execByteCode state
    | otherwise = Error fileFormatError $ "magic number not found"
