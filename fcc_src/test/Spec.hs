import Test.HUnit

import Tests.Compiler.Type (compilerTest)
import Tests.Compiler.Variable (variableTest)
import Tests.Compiler.Operation (operationTest)

tests :: Test
tests = TestList [ "Compiler" ~: compilerTest
                 , "Variable" ~: variableTest
                 , "Operations" ~: operationTest
                 ]

main :: IO Counts
main = runTestTT tests
