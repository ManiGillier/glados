import Test.HUnit
import qualified System.Exit as Exit
import Stack.StackTest
import Arithmetic.Optest

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
  ]

main :: IO ()
main = do
    result <- runTestTT tests
    if failures result > 0 then Exit.exitFailure else Exit.exitSuccess
