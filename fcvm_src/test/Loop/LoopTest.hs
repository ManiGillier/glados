module Loop.LoopTest (testLoop) where

import ByteCode.AsmToBytecode
import DataStruct.Asm
import Test.HUnit hiding (Label)
import VM.Executor

testIfWhile :: [Instruction]
testIfWhile =
  [ Label "func_main",
    Label ".start",
    PushValue 10,
    Label "loop",
    PushValue 0,
    PushFromStackPtrRel 0,
    Diff,
    UpdateZFlag,
    PushLabel "enLoop",
    Zjmp,
    PushValue 41,
    Aff,
    PushValue 1,
    Sub,
    PushLabel "loop",
    Jmp,
    Label "endLoop",
    Ret
  ]

testLoopWIf :: Test
testLoopWIf =
  TestCase $
    let state = execFccByteCode (asmToBytecode testIfWhile)
        states = execAllByteCodes state
     in assertEqual "loop:" [] states

testLoop :: Test
testLoop = TestList $ [testLoopWIf]
