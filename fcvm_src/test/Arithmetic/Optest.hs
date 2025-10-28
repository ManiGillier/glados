module Arithmetic.Optest (testAdd, testSub, testMul, testDivZero, testDiv, testMod, testModZero, testOpAnd, testOpOr, testOpXor, testLBt, testRBt, testEmptySt) where

import ByteCode.AsmToBytecode
import Data.Word
import DataStruct.Asm
import Test.HUnit hiding (Label)
import VM.Executor
import Error.ErrorList
import VM.Types
import VM.Utils.Conversion

baseInst :: [Instruction]
baseInst =
  [ Label "main_func",
    Label ".start"
  ]

retVal :: [Word8]
retVal = replicate 8 0

stackW10 :: [Word8]
stackW10 = int64To8Bytes 10 ++ retVal

testAdd :: Test
testAdd =
  TestCase $
    let pushInst = baseInst ++ [PushValue 5, PushValue 5, Add, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "Add 5 + 5" stackW10 stack

testSub :: Test
testSub =
  TestCase $
    let pushInst = baseInst ++ [PushValue 15, PushValue 5, Sub, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "Sub 15 - 5" stackW10 stack

testMul :: Test
testMul =
  TestCase $
    let pushInst = baseInst ++ [PushValue 5, PushValue 2, Mult, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "Mult 2 * 2" stackW10 stack

testDiv :: Test
testDiv =
  TestCase $
    let pushInst = baseInst ++ [PushValue 20, PushValue 2, Div, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "Div 20 / 2" stackW10 stack

testDivZero :: Test
testDivZero =
  TestCase $
    let pushInst = baseInst ++ [PushValue 20, PushValue 0, Div, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        err = (vmIO op)
     in assertEqual "Div 20 / 0" [(stderrFd, "*** 0 CAN'T BE USE in this operation")] err

testMod :: Test
testMod =
  TestCase $
    let pushInst = baseInst ++ [PushValue 100, PushValue 90, Mod, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "Mod 20 / 2" stackW10 stack

testModZero :: Test
testModZero =
  TestCase $
    let pushInst = baseInst ++ [PushValue 20, PushValue 0, Mod, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        err = (vmIO op)
     in assertEqual "Mod 20 / 0" [(stderrFd, "*** 0 CAN'T BE USE in this operation")] err

testOpAnd :: Test
testOpAnd =
  TestCase $
    let pushInst = baseInst ++ [PushValue 10000, PushValue 1000, BinAnd, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "binAnd 10000 & 1000" (int64To8Bytes 768 ++ retVal) stack

testOpOr :: Test
testOpOr =
  TestCase $
    let pushInst = baseInst ++ [PushValue 2323, PushValue 321, BinOr, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "binOR 2323 | 321" (int64To8Bytes 2387 ++ retVal) stack

testOpXor :: Test
testOpXor =
  TestCase $
    let pushInst = baseInst ++ [PushValue 2323, PushValue 321, Xor, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "binXor 2323 ^ 321" (int64To8Bytes 2130 ++ retVal) stack

testLBt :: Test
testLBt =
  TestCase $
    let pushInst = baseInst ++ [PushValue 2332, PushValue 1, BitShiftLeft, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "binXor 2332 << 1" (int64To8Bytes 4664 ++ retVal) stack

testRBt :: Test
testRBt =
  TestCase $
    let pushInst = baseInst ++ [PushValue 2332, PushValue 1, BitShiftRight, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        op = execByteCode push2
        stack = (vmStack op)
     in assertEqual "binXor 2332 >> 1" (int64To8Bytes 1166 ++ retVal) stack

testEmptySt :: Test
testEmptySt =
  TestCase $
    let pushInst = baseInst ++ [Add, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        err = (vmIO push)
     in assertEqual "stack undeerflow" [(stderrFd, stackUnderFlowError)] err
