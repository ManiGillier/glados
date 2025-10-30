import Test.HUnit

import Stack.StackTest
import Arithmetic.OpTest
import Comparator.CompTest
import Unary.UnaryTest
import Control.ControlTest
import VM.Executor
import VM.Types
import IO.IoTest
import Error.ErrorList
import Loop.LoopTest

testFileFormat :: Test
testFileFormat =
    TestCase $
        let state = execFccByteCode []
            err = (vmIO state)
         in assertEqual "wrong file format" [(stderrFd, fileFormatError)] err

tests :: Test
tests = TestList
  [
    -- File format
    testFileFormat
    -- Stack test
    ,testStack
    -- Arithmetic op
    ,testOp
    -- Comparators 
    ,testCompar
    -- Unary
    ,testUnary
    -- Control
    ,controlTest
    -- IO
    ,ioTest
    -- Loop
    -- ,testLoop
  ]

main :: IO ()
main = runTestTTAndExit tests
