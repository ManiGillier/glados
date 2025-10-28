import Test.HUnit

import Stack.StackTest
import Arithmetic.Optest
import Comparator.Comptest
import Unary.UnaryTest

tests :: Test
tests = TestList
  [
    -- Stack test
     testPushValue
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
  ]

main :: IO ()
main = runTestTTAndExit tests
