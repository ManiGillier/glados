module Control.ControlTest
  ( controlTest,
  )
where

import ByteCode.AsmToBytecode
import Data.Int (Int64)
import Data.Word
import DataStruct.Asm
import Test.HUnit hiding (Label)
import VM.Executor
import VM.Types
import VM.Utils.Conversion (int64To8Bytes)

baseInst :: [Instruction]
baseInst =
  [ Label "main_func",
    Label ".start"
  ]

retVal :: [Word8]
retVal = replicate 8 0

zftest :: Int64 -> (Stack, Word8)
zftest a =
  let pushInst = baseInst ++ [PushValue a, UpdateZFlag, Ret]
      state = execFccByteCode (asmToBytecode pushInst)
      push = execByteCode state
      res = execByteCode push
      stack = (vmStack res)
      zf = (vmZFlag res)
   in (stack, zf)

testZflag :: Test
testZflag =
  TestCase $
    let (stack, zf) = zftest 1
     in assertEqual "zflag: 1" zf 1 >> assertEqual "Stack empty" stack retVal

testZflagNg :: Test
testZflagNg =
  TestCase $
    let (stack, zf) = zftest (-1)
     in assertEqual "zflag: -1" zf 1 >> assertEqual "Stack empty" stack retVal

testZflagZero :: Test
testZflagZero =
  TestCase $
    let (stack, zf) = zftest (0)
     in assertEqual "zflag: 0" zf 0 >> assertEqual "Stack empty" stack retVal

testZjmpTrue :: Test
testZjmpTrue =
  TestCase $
    let pushInst = baseInst ++ [PushValue 1, UpdateZFlag, PushValue 8, Zjmp, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        updz = execByteCode push
        pushVal = execByteCode updz
        zjmp = execByteCode pushVal
        pc = (vmPC zjmp)
        pcBase = (vmPC pushVal)
     in assertEqual "zjmp: 1" (pcBase + 1) pc

testZjmpFalse :: Test
testZjmpFalse =
  TestCase $
    let pushInst = baseInst ++ [PushValue 0, UpdateZFlag, PushValue 8, Zjmp, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        updz = execByteCode push
        pushVal = execByteCode updz
        zjmp = execByteCode pushVal
        pc = (vmPC zjmp)
     in assertEqual "zjmp: 0" 8 pc

testjmp :: Test
testjmp =
  TestCase $
    let pushInst = baseInst ++ [PushValue 8, Jmp, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        jmp = execByteCode push
        pc = (vmPC jmp)
     in assertEqual "jmp: 0" 8 pc

testRet :: Test
testRet =
  TestCase $
    let pushInst = baseInst ++ [Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        ret = execByteCode state
        ret1 = execByteCode ret
        end = (vmEnd ret1)
        stack = (vmStack ret1)
     in assertEqual "ret:" end True >> assertEqual "stack empy" stack (replicate 8 0)

testCallRetFunc :: Test
testCallRetFunc =
  TestCase $
    let pushInst =
          [ Label "func_main",
            Label ".start",
            PushValue 1,
            PushLabel "func_foo",
            Call,
            Ret,
            Label "func_foo",
            Ret
          ]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        pushla = execByteCode push
        call = execByteCode pushla
        ret = execByteCode call
        retaf = execByteCode ret
        cs = (vmCallStack call)
        stack = (vmStack retaf)
        csAftRet = (vmCallStack ret)
     in assertEqual "call" [(27, 8)] cs >> assertEqual "ret" [] csAftRet 
        >> assertEqual "stack empy" stack (int64To8Bytes 1 ++ replicate 8 0)


testRetVal :: Test
testRetVal =
  TestCase $
    let pushInst =
          [ Label "func_main",
            Label ".start",
            Ret
          ]
        state = execFccByteCode (asmToBytecode pushInst)
        ret = execByteCode state
        ret1 = execByteCode ret
        cs = (vmCallStack ret1)
        retValue = (vmRetVal ret1)
     in assertEqual "ret" cs [] >> assertEqual "retVal ->" (Just 0) retValue

controlTest :: Test
controlTest =
  TestList
    [ testZflag,
      testZflagNg,
      testZflagZero,
      testZjmpTrue,
      testZjmpFalse,
      testjmp,
      testRet,
      testCallRetFunc,
      testRetVal
    ]
