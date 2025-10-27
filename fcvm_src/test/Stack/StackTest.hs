module Stack.StackTest (testPushValue, testPopEmpty, testPushFromStPtrR, testPopFromStPtrR, testPushLabel) where

import ByteCode.AsmToBytecode
import DataStruct.Asm
import Test.HUnit hiding (Label)
import VM.Executor
import VM.Types
import VM.Utils.Conversion
import Data.Word

baseInst :: [Instruction]
baseInst =
  [ Label "main_func",
    Label ".start"
  ]

stackW10 :: [Word8]
stackW10 = int64To8Bytes 10

testPushValue :: Test
testPushValue =
  TestCase $
    let pushInst = baseInst ++ [PushValue 10, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        stack = (vmStack push)
     in assertEqual "push val 10" stackW10 stack

testPushLabel :: Test
testPushLabel =
  TestCase $
    let pushInst = baseInst ++ [Label "loop", PushLabel "loop", Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        stack = (vmStack push)
     in assertEqual "pushlabel loop" (int64To8Bytes 8) stack

testPopEmpty :: Test
testPopEmpty =
  TestCase $
    let pushInst = baseInst ++ [PushValue 10, PopEmpty, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        pop = execByteCode push
        stack = (vmStack pop)
     in assertEqual "pop val 10" [] stack

testPushFromStPtrR :: Test
testPushFromStPtrR =
  TestCase $
    let pushInst = baseInst ++ [PushValue 10, PushFromStackPtrRel 0, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        pushFromRel = execByteCode push
        stack = (vmStack pushFromRel)
     in assertEqual "pushFromStackPtrRel 0 with one elem" (stackW10 ++ stackW10) stack

testPopFromStPtrR :: Test
testPopFromStPtrR =
  TestCase $
    let pushInst = baseInst ++ [PushValue 10, PushValue 42, PopToStackPtrRel 0, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        pop = execByteCode push2
        stack = (vmStack pop)
     in assertEqual "popFromStackPtrRel 8 with one elem" (int64To8Bytes 42) stack
