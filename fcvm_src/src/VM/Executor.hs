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
import VM.Instructions.Comparator
import VM.Instructions.Unary
import VM.Instructions.IO
import VM.Instructions.Control
import VM.Instructions.Stack
import VM.Utils.Conversion
import VM.ByteCode
import VM.Labels 
import Data.Int (Int64)
import Data.Bits

dispatchInstruction :: Byte -> VMState -> MaybeError String
dispatchInstruction opcode state = dispatchStackInstruction opcode state

dispatchStackInstruction :: Byte -> VMState -> MaybeError String
dispatchStackInstruction 89 s = execByteCode $ handlePushValue s
dispatchStackInstruction 91 s = execByteCode $ handlePushValue s
dispatchStackInstruction 30 s = execByteCode $ handlePopToStackPtrRel s
dispatchStackInstruction 29 s = execByteCode $ handlePushFromStackPtrRel s
dispatchStackInstruction op state = dispatchArithmeticInstruction op state

handleArithmInst :: (Int64 -> Int64 -> Int64) -> VMState -> MaybeError String
handleArithmInst f state = 
    case handleOp f state of
        Correct newState -> execByteCode newState
        Error err msg    -> Error err msg

handleCompInst :: (Int64 -> Int64 -> Bool) -> VMState -> MaybeError String
handleCompInst f state = 
    case handleComp f state of
        Correct newState -> execByteCode newState
        Error err msg    -> Error err msg

handleCompBoolInst :: (Bool -> Bool -> Bool) -> VMState -> MaybeError String
handleCompBoolInst f state = 
    case handleBoolComp f state of
        Correct newState -> execByteCode newState
        Error err msg    -> Error err msg

dispatchArithmeticInstruction :: Byte -> VMState -> MaybeError String
dispatchArithmeticInstruction 13 state = handleArithmInst (+) state
dispatchArithmeticInstruction 14 state = handleArithmInst (-) state
dispatchArithmeticInstruction 15 state = handleArithmInst (*) state
dispatchArithmeticInstruction 16 state = handleArithmInst Prelude.div state
dispatchArithmeticInstruction 17 state = handleArithmInst Prelude.mod state
dispatchArithmeticInstruction 6 state = handleArithmInst ((.&.)) state
dispatchArithmeticInstruction 7 state = handleArithmInst ((.|.)) state
dispatchArithmeticInstruction 10 state = handleArithmInst (xor) state
dispatchArithmeticInstruction 11 state = 
    execByteCode $ handleBitshift (shiftL) state
dispatchArithmeticInstruction 12 state = 
    execByteCode $ handleBitshift (shiftR) state
dispatchArithmeticInstruction op state = dispatchComparInstruction op state

dispatchComparInstruction :: Byte -> VMState -> MaybeError String
dispatchComparInstruction 8 state = handleCompBoolInst (&&) state
dispatchComparInstruction 9 state = handleCompBoolInst (||) state
dispatchComparInstruction 18 state = handleCompInst (>) state
dispatchComparInstruction 19 state = handleCompInst (>=) state
dispatchComparInstruction 20 state = handleCompInst (<) state
dispatchComparInstruction 21 state = handleCompInst (<=) state
dispatchComparInstruction 22 state = handleCompInst (==) state
dispatchComparInstruction 23 state = handleCompInst (/=) state
dispatchComparInstruction op state = dispatchUnaryInstruction op state

dispatchUnaryInstruction :: Byte -> VMState -> MaybeError String
dispatchUnaryInstruction 3 state = execByteCode $ handleBinNot state
dispatchUnaryInstruction 4 state = execByteCode $ handleNot state
dispatchUnaryInstruction 5 state = execByteCode $ handleNegate state
dispatchUnaryInstruction op state = dispatchControlInstruction op state

dispatchControlInstruction :: Byte -> VMState -> MaybeError String
dispatchControlInstruction 34 state = execByteCode $ handleCall state
dispatchControlInstruction 35 state = 
    case handleRet state of
        Nothing      -> Correct ""
        Just newState -> execByteCode newState
dispatchControlInstruction 24 state = execByteCode $ handleZflag state
dispatchControlInstruction 36 state = execByteCode $ handleJmp state
dispatchControlInstruction 37 state = execByteCode $ handleZjmp state
dispatchControlInstruction 39 state =
    execByteCode $ state { vmPC = skipVal (vmPC state) }
dispatchControlInstruction op state = dispatchIoInstruction op state

dispatchIoInstruction :: Byte -> VMState -> MaybeError String
dispatchIoInstruction 38 state = let (char, newState) = handleAff state
      in ((:) char) <$> execByteCode newState
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
                [] 0 [] (indexLabel cleanByteCode) 0
        in execByteCode state
    | otherwise = Error fileFormatError $ "magic number not found"
