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

dispatchInstruction :: Byte -> VMState -> MaybeError String
dispatchInstruction opcode state = dispatchStackInstruction opcode state

dispatchStackInstruction :: Byte -> VMState -> MaybeError String
dispatchStackInstruction opcode state =
    case opcode of
        89 -> execByteCode' $ handlePushValue state
        91 -> execByteCode' $ handlePushValue state
        30 -> execByteCode' $ handlePopToStackPtrRel state
        29 -> execByteCode' $ handlePushFromStackPtrRel state
        _  -> dispatchArithmeticinstruction opcode state

dispatchArithmeticinstruction :: Byte -> VMState -> MaybeError String
dispatchArithmeticinstruction opcode state =
    case opcode of
        13 -> case handleAdd state of
                Correct newState -> execByteCode' newState
                Error err msg    -> Error err msg
        _  -> dispatchControlInstruction opcode state

dispatchControlInstruction :: Byte -> VMState -> MaybeError String
dispatchControlInstruction opcode state =
    case opcode of
        34 -> execByteCode' $ handleCall state
        35 -> case handleRet state of
                Nothing      -> Correct ""
                Just newState -> execByteCode' newState
        _ -> dispatchIoInstruction opcode state

dispatchIoInstruction :: Byte -> VMState -> MaybeError String
dispatchIoInstruction opcode state =
    case opcode of
        38 -> let (char, newState) = handleAff state
              in case execByteCode' newState of
                    Correct rest -> Correct (char : rest)
                    Error err msg -> Error err msg
        _ -> execByteCode' $ state { vmPC = nextIns (vmPC state) }

execByteCode' :: VMState -> MaybeError String
execByteCode' state
    | isInstruction (vmByteCode state) (vmPC state) = 
        let opcode = vmByteCode state !! vmPC state
        in dispatchInstruction opcode state
    | otherwise = 
        execByteCode' $ state { vmPC = nextIns (vmPC state) }

execByteCode :: ByteCode -> PC -> Stack -> SP -> CallStack -> LabelIndex -> MaybeError String
execByteCode bc pc st sp cs lab =
    let state = VMState bc pc st sp cs lab
    in execByteCode' state

execFccByteCode :: [Word8] -> MaybeError String
execFccByteCode byteCode
    | checkMagicNumber byteCode = 
        let cleanByteCode = drop 4 byteCode
            pc = bytesToInt64 (take 8 cleanByteCode)
        in execByteCode cleanByteCode 
            (fromIntegral pc + 8) [] 0 [] (indexLabel cleanByteCode)
    | otherwise = Error fileFormatError $ "magic number not found"
