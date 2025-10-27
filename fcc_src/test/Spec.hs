import Test.HUnit

import Tests.Compiler.Type (compilerTest)
import Tests.Compiler.Variable (variableTest)
import Tests.Compiler.Operation (operationTest)
import Tests.Compiler.FunctionBody (functionBodyTest)
import Tests.Compiler.FunctionDef (functionDefTest)
import Tests.Compiler.Ast (astTest)
import Tests.Combinor.Ast (combineAstTest)
import Tests.Lexer.Lexer (lexerTest)

tests :: Test
tests = TestList [ "Compiler" ~: compilerTest
                 , "Variable" ~: variableTest
                 , "Operations" ~: operationTest
                 , "FunctionBody" ~: functionBodyTest
                 , "FunctionDef" ~: functionDefTest
                 , "Ast" ~: astTest
                 , "Combinor" ~: combineAstTest
                 , "Lexer" ~: lexerTest
                 ]

main :: IO ()
main = runTestTTAndExit tests
