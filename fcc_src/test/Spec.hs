import Test.HUnit

import Tests.Compiler.Type (compilerTest)
import Tests.Compiler.Variable (variableTest)
import Tests.Compiler.Operation (operationTest)
import Tests.Compiler.FunctionBody (functionBodyTest)

tests :: Test
tests = TestList [ "Compiler" ~: compilerTest
                 , "Variable" ~: variableTest
                 , "Operations" ~: operationTest
                 , "FunctionBody" ~: functionBodyTest
                 ]

main :: IO Counts
main = runTestTT tests
