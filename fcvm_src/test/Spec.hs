import Test.HUnit

import Stack.StackTest
import Arithmetic.Optest
import Comparator.Comptest
import Unary.UnaryTest
import Control.ControlTest
import VM.Executor
import VM.Types
import IO.IoTest
import Error.ErrorList

testBcFormat :: Test
testBcFormat =
    TestCase $
        let state = execFccByteCode []
            err = (vmIO state)
         in assertEqual "wrong file format" [(stderrFd, fileFormatError)] err

tests :: Test
tests = TestList
  [
    testBcFormat
    -- Stack test
    ,testPushValue
    ,testPopEmpty
    ,testPushFromStPtrR
    ,testPopFromStPtrR
    ,testPushLabel
    -- Arithmetic op
    ,testAdd
    ,testSub
    ,testMul
    ,testDiv
    ,testDivZero
    ,testMod
    ,testModZero
    ,testOpAnd
    ,testOpXor
    ,testOpOr
    ,testRBt
    ,testLBt
    ,testEmptySt
    -- Comparators 
    ,testAndTrue
    ,testAndFalse
    ,testAndTrueneg
    ,testOrTrue
    ,testOrFalse
    ,testOrTrueNeg
    ,testBoolStEmpty
    ,testGrEF
    ,testGrET
    ,testGrF
    ,testGrT
    ,testLtEF
    ,testLtET
    ,testLtF
    ,testLtT
    ,testCompStEmpty
    ,testEqTrue
    ,testEqFalse
    ,testDiffFalse
    ,testDiffTrue
    -- Unary
    ,testNegate1
    ,testNegate2
    ,testBinNot
    ,testBinNot2
    ,testNot
    ,testNot2
    -- Control
    ,controlTest
    -- IO
    ,ioTest
  ]

main :: IO ()
main = runTestTTAndExit tests
