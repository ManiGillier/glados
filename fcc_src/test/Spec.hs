import Test.HUnit

import Tests.Compiler.Type (compilerTest)

tests :: Test
tests = TestList [ "Compiler" ~: compilerTest
                 ]

main :: IO Counts
main = runTestTT tests
