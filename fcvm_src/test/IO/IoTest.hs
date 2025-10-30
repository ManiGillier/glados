module IO.IoTest (
ioTest
) where

import ByteCode.AsmToBytecode
import DataStruct.Asm
import Test.HUnit hiding (Label)
import VM.Executor
import VM.Types

baseInst :: [Instruction]
baseInst =
  [ Label "main_func",
    Label ".start"
  ]

testAff :: Test
testAff =
    TestCase $
        let pushInst = baseInst ++ [PushValue 42, Aff, Ret]
            state = execFccByteCode (asmToBytecode pushInst)
            push = execByteCode state
            aff = execByteCode push
            buffer = (vmIO aff)
            stack = (vmStack aff)
         in assertEqual "aff: '*'" buffer [(stdoutFd, "*")] >> assertEqual "stack empty" (replicate 8 0) stack

testAffs :: Test
testAffs =
    TestCase $
        let pushInst = baseInst ++ [Affs "hello", Ret]
            state = execFccByteCode (asmToBytecode pushInst)
            affs = execByteCode state
            buffer = (vmIO affs)
            stack = (vmStack affs)
         in assertEqual "aff: '*'" buffer [(stdoutFd, "hello")] >> assertEqual "stack empty" (replicate 8 0) stack

ioTest :: Test
ioTest =
  TestList [testAff, testAffs]
