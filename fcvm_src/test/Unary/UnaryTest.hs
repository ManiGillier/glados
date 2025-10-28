module Unary.UnaryTest (
    testNegate1
    ,testNegate2
    ,testBinNot
    ,testBinNot2
    ,testNot
    ,testNot2
) where

import ByteCode.AsmToBytecode
import Data.Word
import DataStruct.Asm
import Test.HUnit hiding (Label)
import VM.Executor
import VM.Types
import VM.Utils.Conversion
import Data.Int (Int64)

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

testUnary :: Int64 -> Instruction -> Stack
testUnary a op =
    let pushInst = baseInst ++ [PushValue a, op , Ret]
        state = execFccByteCode (asmToBytecode pushInst)
        push = execByteCode state
        res = execByteCode push
        stack = (vmStack res)
    in stack

testBinNot :: Test
testBinNot = TestCase $
    assertEqual "BinNot: ~ 5" (int64To8Bytes (-6) ++ retVal) (testUnary 5 BinNot)

testBinNot2 :: Test
testBinNot2 = TestCase $
    assertEqual "BinNot: ~ 1" (int64To8Bytes (-3001) ++ retVal) (testUnary 3000 BinNot)

testNot :: Test
testNot = TestCase $
    assertEqual "Not: 5" stackW0 (testUnary 5 BoolNot)

testNot2 :: Test
testNot2 = TestCase $
    assertEqual "Not: 0" stackW1 (testUnary 0 BoolNot)

testNegate1 :: Test
testNegate1 = TestCase $
    assertEqual "Negate: -1" stackW1 (testUnary (-1) Negate)

testNegate2 :: Test
testNegate2 = TestCase $
    assertEqual "Negate: 0" stackW0 (testUnary 0 Negate)
