module Main where
import Lisp.Exec.Exec as Exec
import Lisp.DataStruct.Ast as Ast
import Test.HUnit
import qualified System.Exit as Exit
import Error.MaybeError (MaybeError(..))
import Lisp.Exec.SymboleTable (Value(VBool))

testValue42 :: Test
testValue42 = TestCase $
  let (output, _) = Exec.execLisp (Value 42) []
  in assertEqual "Value 42" (Correct "42") output

testValueMinus1 :: Test
testValueMinus1 = TestCase $
  let (output, _) = Exec.execLisp (Value (-1)) []
  in assertEqual "Value -1" (Correct "-1") output

testValue0 :: Test
testValue0 = TestCase $
  let (output, _) = Exec.execLisp (Value 0) []
  in assertEqual "Value 0" (Correct "0") output

testBigNum :: Test
testBigNum = TestCase $
  let bigNum = 9223372036854775807
      (output, _) = Exec.execLisp (Value bigNum) []
  in assertEqual "Big number" (Correct (show bigNum)) output

testDefineX :: Test
testDefineX = TestCase $
  let (_, env) = Exec.execLisp (Define "x" (Value 42)) []
      (result, _) = Exec.execLisp (Symbol "x") env
  in assertEqual "Define x" (Correct "42") result

testDefine :: Test
testDefine = TestCase $
  let (result, _) = Exec.execLisp (Define "x" (Value 42)) []
  in assertEqual "Define" (Correct []) result

testDefineY :: Test
testDefineY = TestCase $
  let (_, env) = Exec.execLisp (Define "y" (Value (-1))) []
      (result, _) = Exec.execLisp (Symbol "y") env
  in assertEqual "Define y" (Correct "-1") result

testSymbolX :: Test
testSymbolX = TestCase $
  let (_, env) = Exec.execLisp (Define "x" (Value 42)) []
      (result, _) = Exec.execLisp (Symbol "x") env
  in assertEqual "Symbol x" (Correct "42") result

testAdd :: Test
testAdd = TestCase $
  let (result, _) = Exec.execLisp (Call "+" [Value 10, Value 5]) []
  in assertEqual "Add 10 and 5" (Correct "15") result

testMinus :: Test
testMinus = TestCase $
  let (result, _) = Exec.execLisp (Call "-" [Value 10, Value 5]) []
  in assertEqual "Subtract 5 from 10" (Correct "5") result

testMultiply :: Test
testMultiply = TestCase $
  let (result, _) = Exec.execLisp (Call "*" [Value 10, Value 5]) []
  in assertEqual "Multiply 10 and 5" (Correct "50") result

testDiv :: Test
testDiv = TestCase $
  let (result, _) = Exec.execLisp (Call "div" [Value 20, Value 4]) []
  in assertEqual "Divide 20 by 4" (Correct "5") result

testDivFloat :: Test
testDivFloat = TestCase $
  let (result, _) = Exec.execLisp (Call "div" [Value 7, Value 2]) []
  in assertEqual "Divide 7 by 2" (Correct "3") result

testMod :: Test
testMod = TestCase $
  let (result, _) = Exec.execLisp (Call "mod" [Value 20, Value 6]) []
  in assertEqual "Mod 20 by 6" (Correct "2") result

testEqTrue :: Test
testEqTrue = TestCase $
  let (result, _) = Exec.execLisp (Call "eq?" [Value 5, Value 5]) []
  in assertEqual "5 should equal 5" (Correct "#t") result

testEqFalse :: Test
testEqFalse = TestCase $
  let (result, _) = Exec.execLisp (Call "eq?" [Value 5, Value 3]) []
  in assertEqual "5 should not equal 3" (Correct "#f") result

testBigger :: Test
testBigger = TestCase $
  let (result, _) = Exec.execLisp (Call "<" [Value 3, Value 5]) []
  in assertEqual "3 should be less than 5" (Correct "#t") result

testBiggerFalse :: Test
testBiggerFalse = TestCase $
  let (result, _) = Exec.execLisp (Call "<" [Value 5, Value 3]) []
  in assertEqual "5 should not be less than 3" (Correct "#f") result

testAddVariadic :: Test
testAddVariadic = TestCase $
  let (result, _) = Exec.execLisp (Call "+" [Value 1, Value 2, Value 3]) []
  in assertEqual "Add 1, 2, and 3" (Correct "6") result

testMinusVariadic :: Test
testMinusVariadic = TestCase $
  let (result, _) = Exec.execLisp (Call "-" [Value 5, Value 3, Value 1]) []
  in assertEqual "Subtract 3 and 1 from 5" (Correct "1") result

testMultiplyVariadic :: Test
testMultiplyVariadic = TestCase $ 
  let (result, _) = Exec.execLisp (Call "*" [Value 2, Value 3, Value 4]) []
  in assertEqual "Multiply 2, 3, and 4" (Correct "24") result

testAddDefine :: Test
testAddDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 10)) []
      (result, _) = Exec.execLisp (Call "+" [Symbol "x", Value 5]) env
  in assertEqual "Add x and 5" (Correct "15") result

testMinusDefine :: Test
testMinusDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 10)) []
      (result, _) = Exec.execLisp (Call "-" [Symbol "x", Value 3]) env
  in assertEqual "Subtract 3 from x" (Correct "7") result

testMultiplyDefine :: Test
testMultiplyDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 4)) []
      (result, _) = Exec.execLisp (Call "*" [Symbol "x", Value 2]) env
  in assertEqual "Multiply x by 2" (Correct "8") result

testDivDefine :: Test
testDivDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 20)) []
      (result, _) = Exec.execLisp (Call "div" [Symbol "x", Value 4]) env
  in assertEqual "Divide x by 4" (Correct "5") result

testDivFloatDefine :: Test
testDivFloatDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 7)) []
      (result, _) = Exec.execLisp (Call "div" [Symbol "x", Value 2]) env
  in assertEqual "Divide x by 2" (Correct "3") result

testModDefine :: Test
testModDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 20)) []
      (result, _) = Exec.execLisp (Call "mod" [Symbol "x", Value 6]) env
  in assertEqual "Mod x by 6" (Correct "2") result

testEqTrueDefine :: Test
testEqTrueDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 42)) []
      (result, _) = Exec.execLisp (Call "eq?" [Symbol "x", Value 42]) env
  in assertEqual "x should equal 42" (Correct "#t") result

testEqFalseDefine :: Test
testEqFalseDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 42)) []
      (result, _) = Exec.execLisp (Call "eq?" [Symbol "x", Value 5]) env
  in assertEqual "x should equal 42" (Correct "#f") result

testBiggerDefine :: Test
testBiggerDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 41)) []
      (result, _) = Exec.execLisp (Call "<" [Symbol "x", Value 42]) env
  in assertEqual "x should be less than 42" (Correct "#t") result

testBiggerFalseDefine :: Test
testBiggerFalseDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 43)) []
      (result, _) = Exec.execLisp (Call "<" [Symbol "x", Value 42]) env
  in assertEqual "x should not be greater than 42" (Correct "#f") result

testAddVariadicDefine :: Test
testAddVariadicDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 10)) []
      (result, _) = Exec.execLisp (Call "+" [Symbol "x", Value 5, Value 3]) env
  in assertEqual "Add x, 5, and 3" (Correct "18") result

testMinusVariadicDefine :: Test
testMinusVariadicDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 20)) []
      (result, _) = Exec.execLisp (Call "-" [Symbol "x", Value 5, Value 3]) env
  in assertEqual "Subtract 5 and 3 from x" (Correct "12") result

testMultiplyVariadicDefine :: Test
testMultiplyVariadicDefine = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 2)) []
      (result, _) = Exec.execLisp (Call "*" [Symbol "x", Value 3, Value 4]) env
  in assertEqual "Multiply x, 3, and 4" (Correct "24") result

testIfEqual :: Test
testIfEqual = TestCase $ 
  let (result, _) = Exec.execLisp (If (Value 5) (Value 42) (Value 0)) []
  in assertEqual "If true then 42" (Correct "42") result

testIfFalse :: Test
testIfFalse = TestCase $ 
  let (result, _) = Exec.execLisp (If (Value 0) (Value 42) (Value 0)) []
  in assertEqual "If false then 0" (Correct "0") result


testIfFalseBool :: Test
testIfFalseBool = TestCase $ 
  let (result, _) = Exec.execLisp (If (Boolean True) (Value 42) (Value 0)) []
  in assertEqual "If true then 42" (Correct "42") result

testIfFalseBoolFalse :: Test
testIfFalseBoolFalse = TestCase $ 
  let (result, _) = Exec.execLisp (If (Boolean False) (Value 42) (Value 0)) []
  in assertEqual "If false then 0" (Correct "0") result

testStringTable :: Test
testStringTable = TestCase $ 
  let (_, env) = Exec.execLisp (Define "x" (Value 10)) []
      (_, env2) = Exec.execLisp (Define "y" (Value 20)) env
      (result, _) = Exec.execLisp (Call "+" [Symbol "x", Symbol "y"]) env2
  in assertEqual "Add x and y" (Correct "30") result

testNotBoundErrorHandling :: Test
testNotBoundErrorHandling = TestCase $
  let (result, _) = Exec.execLisp (Symbol "undefinedVar") []
  in assertEqual "Error on undefined variable" (Error "*** ERROR : variable undefinedVar is not bound" "") result

testEvalBuiltinCallError :: Test
testEvalBuiltinCallError = TestCase $
  let (result, _) = Exec.execLisp (Call "div" [Value 1, Value 2, Value 3, Value 4]) []
  in assertEqual "Eval builtin call" (Error "*** ERROR : wrong number of argument of 4 in call (div Value 1 Value 2 Value 3 Value 4)" "") result

testNonProcedError :: Test
testNonProcedError = TestCase $
  let (result, _) = Exec.execLisp (Call "nonProc" [Value 1]) []
  in assertEqual "Error on calling lambda not define" (Error "*** ERROR : variable nonProc is not bound" "") result

testNonProcedError2 :: Test
testNonProcedError2 = TestCase $
  let (_, env) = Exec.execLisp (Define "f" (Value 10)) []
      (result, _) = Exec.execLisp (Call "f" [Value 1]) env
  in assertEqual "Error on calling non-procedure" (Error "*** ERROR : attempt to apply non-procedure 10" "") result

testProcedureError :: Test
testProcedureError = TestCase $
    let (result, _) = Exec.execLisp ((Lambda ["a", "b"] (Call "+" [Symbol "a", Symbol "b"]))) []
    in assertEqual "Error on calling non-procedure" (Error "#<procedure>" "") result

testLambdaAnonymous :: Test
testLambdaAnonymous = TestCase $
  let lambdaAst = Lambda ["x"] (Call "+" [Symbol "x", Value 5])
      (result, _) = Exec.execLisp (Apply lambdaAst [Value 10]) []
  in assertEqual "Lambda application" (Correct "15") result

testLambda :: Test
testLambda = TestCase $
    let (_, env) = Exec.execLisp (Define "add5" (Lambda ["a", "b"] (Call "+" [Symbol "a", Symbol "b"]))) []
        (result, _) = Exec.execLisp (Call "add5" [Value 10, Value 5]) env
    in assertEqual "Define and call lambda" (Correct "15") result

-- TEST renturded env 
testDefineBoolEnv :: Test
testDefineBoolEnv = TestCase $
  let (_, env) = Exec.execLisp (Define "x" (Boolean True)) []
  in assertEqual "env equal at" [("x", (VBool True))] env 

tests :: Test
tests = TestList
  [ testValue42
  , testValueMinus1
  , testValue0
  , testBigNum
  , testDefine
  , testDefineX
  , testDefineY
  , testDefineBoolEnv
  , testSymbolX
  , testAdd
  , testMinus
  , testMultiply
  , testDiv
  , testDivFloat
  , testMod
  , testEqTrue
  , testEqFalse
  , testBigger
  , testBiggerFalse
  , testAddVariadic
  , testMinusVariadic
  , testMultiplyVariadic
  , testAddDefine
  , testMinusDefine
  , testMultiplyDefine
  , testDivDefine
  , testDivFloatDefine
  , testModDefine
  , testEqTrueDefine
  , testEqFalseDefine
  , testBiggerDefine
  , testBiggerFalseDefine
  , testAddVariadicDefine
  , testMinusVariadicDefine
  , testMultiplyVariadicDefine
  , testIfEqual
  , testIfFalse
  , testIfFalseBool
  , testIfFalseBoolFalse
  , testStringTable
  , testNotBoundErrorHandling
  , testEvalBuiltinCallError
  , testNonProcedError
  , testNonProcedError2
  , testProcedureError
  , testLambdaAnonymous
  , testLambda
  ]

main :: IO ()
main = do
    result <- runTestTT tests
    if failures result > 0 then Exit.exitFailure else Exit.exitSuccess
