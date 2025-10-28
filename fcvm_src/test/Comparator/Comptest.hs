module Comparator.Comptest (testAndTrue, testAndTrueneg, testAndFalse,
testOrTrue, testOrFalse, testOrTrueNeg, testBoolStEmpty, testGrEF, testGrET, testGrF, testGrT,
testLtEF, testLtET, testLtF, testLtT, testCompStEmpty, testEqTrue, testEqFalse, testDiffFalse, testDiffTrue) where

import ByteCode.AsmToBytecode
import Data.Word
import DataStruct.Asm
import Test.HUnit hiding (Label)
import VM.Executor
import VM.Types
import VM.Utils.Conversion
import Data.Int (Int64)
import Error.ErrorList 

baseInst :: [Instruction]
baseInst =
  [ Label "main_func",
    Label ".start"
  ]

retVal :: [Word8]
retVal = replicate 8 0

stackW1 :: [Word8]
stackW1 = int64To8Bytes 1 ++ retVal


stackW0 :: [Word8]
stackW0 = int64To8Bytes 0 ++ retVal

testComp :: Int64 -> Int64 -> Instruction -> Stack
testComp a b op =
    let pushInst = baseInst ++ [PushValue a, PushValue b, op , Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        push2 = execByteCode push
        res = execByteCode push2
        stack = (vmStack res)
    in stack

testAndTrue :: Test
testAndTrue =
  TestCase $
     assertEqual "And: 5 && 5" stackW1 (testComp 5 5 BoolAnd)

testAndFalse :: Test
testAndFalse =
  TestCase $
     assertEqual "And: 5 && 0" stackW0 (testComp 5 0 BoolAnd)

testAndTrueneg :: Test
testAndTrueneg =
  TestCase $
     assertEqual "And: 5 && -1" stackW0 (testComp 5 (-1) BoolAnd)

testOrTrue:: Test
testOrTrue =
  TestCase $
     assertEqual "And: 5 || 5" stackW1 (testComp 5 5 BoolOr)

testOrFalse :: Test
testOrFalse =
  TestCase $
    assertEqual "And: 0 || 0" stackW0 (testComp 0 0 BoolOr)

testOrTrueNeg :: Test
testOrTrueNeg =
  TestCase $
    assertEqual "And: 0 || -1" stackW0 (testComp 0 (-1) BoolOr)

testBoolStEmpty :: Test
testBoolStEmpty =
  TestCase $
    let pushInst = baseInst ++ [BoolAnd, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        err = (vmIO push)
     in assertEqual "And: 5 && 5" [(stderrFd, stackUnderFlowError)] err

testGrT :: Test
testGrT =
  TestCase $
    assertEqual "gt: 0 > -1" stackW1 (testComp 0 (-1) Gt)

testGrF :: Test
testGrF =
  TestCase $
    assertEqual "gt: -2 > -1" stackW1 (testComp (-1) (-2) Gt)

testGrET :: Test
testGrET =
  TestCase $
    assertEqual "gt: 2 >= 2" stackW1 (testComp 2 2 Ge)

testGrEF :: Test
testGrEF =
  TestCase $
    assertEqual "gt: 2 >= 3" stackW1 (testComp 3 2 Ge)

testLtT :: Test
testLtT =
  TestCase $
    assertEqual "le: -1 < 0" stackW1 (testComp (-1) (0) Lt)

testLtF :: Test
testLtF =
  TestCase $
    assertEqual "le: -2 < -1" stackW1 (testComp (-2) (-1) Lt)

testLtET :: Test
testLtET =
  TestCase $
    assertEqual "le: 2 <= 2" stackW1 (testComp 2 2 Le)

testLtEF :: Test
testLtEF =
  TestCase $
    assertEqual "le: 2 <= 3" stackW1 (testComp 2 3 Le)

testCompStEmpty :: Test
testCompStEmpty =
  TestCase $
    let pushInst = baseInst ++ [Le, Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        err = (vmIO push)
     in assertEqual "Comparaison wirh empty stack" [(stderrFd, stackUnderFlowError)] err

testEqTrue :: Test
testEqTrue =
  TestCase $
    assertEqual "Eq: 2 == 2" stackW1 (testComp 2 2 Eq)

testEqFalse :: Test
testEqFalse =
  TestCase $
    assertEqual "Eq: 2 == 3" stackW0 (testComp 2 3 Eq)

testDiffTrue :: Test
testDiffTrue =
  TestCase $
    assertEqual "Diff: 2 != 2" stackW0 (testComp 2 2 Diff)

testDiffFalse :: Test
testDiffFalse =
  TestCase $
    assertEqual "Diff: 2 != 3" stackW1 (testComp 2 3 Diff)
