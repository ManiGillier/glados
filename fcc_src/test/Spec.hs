import Test.HUnit

import Tests.Compiler.Type (compilerTest)
import Tests.Compiler.Variable (variableTest)

tests :: Test
tests = TestList [ "Compiler" ~: compilerTest
                 , "Variable" ~: variableTest
                 ]

main :: IO Counts
main = runTestTT tests
