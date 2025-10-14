{-
-- EPITECH PROJECT, 2025
-- glados tests
-- File description:
-- test compiler type
-}

module Tests.Compiler.Type (compilerTest) where

import Test.HUnit

import DataStruct.Asm (Instruction (..))
import Error.MaybeError (MaybeError (..))
import Compiler.Type
import Error.ErrorList (ukVarErr)
import Compiler.Type (revCompiler, mapCompiler, baseContext, Context (functionNames))

testCompiler :: Compiler [Instruction]
testCompiler s l = Correct (s, l)

conditionCompiler :: Compiler Bool
conditionCompiler s True = Correct (s, [Jmp])
conditionCompiler _ False = Error "test" "test"

testFailCompiler :: Compiler a
testFailCompiler _ _ = Error "test" "test"

compilerTest :: Test
compilerTest = TestList
  [ "varExist" ~: varExist baseContext "x" ~?= False
  , "takeLabel" ~: takeLabel "label" (Context [] 0 []) ~?=
      (Context [] 1 [], "label_0")
  , "baseContext" ~: baseContext ~?= (Context [] 0 [])
  , "prefixCompiler" ~:
    [ "Error compiler" ~: prefixCompiler [Jmp]
      testFailCompiler baseContext ""
      ~?= Error "test" "test"
    , "Working compiler" ~: prefixCompiler [Jmp]
      testCompiler baseContext [Zjmp]
      ~?= Correct (baseContext, [Jmp, Zjmp])
    ]
  , "suffixCompiler" ~:
    [ "Error compiler" ~: suffixCompiler [Jmp]
      testFailCompiler baseContext ""
      ~?= Error "test" "test"
    , "Working compiler" ~: suffixCompiler [Jmp]
      testCompiler baseContext [Zjmp]
      ~?= Correct (baseContext, [Zjmp, Jmp])
    ]
  , "mapCompiler" ~:
    [ "Empty" ~: mapCompiler conditionCompiler
      baseContext []
      ~?= Correct (baseContext, [])
    , "Second errored" ~: mapCompiler conditionCompiler
      baseContext [True, False, True]
      ~?= Error "test" "test"
    , "No error" ~: mapCompiler conditionCompiler
      baseContext [True, True, True]
      ~?= Correct (baseContext, [Jmp, Jmp, Jmp])
    ]
  , "combine" ~:
    [ "First fail" ~: combine testFailCompiler testCompiler
      baseContext (10 :: Int, [Jmp])
      ~?= Error "test" "test"
    , "Second fail" ~: combine testCompiler testFailCompiler
      baseContext ([Jmp], 10 :: Int)
      ~?= Error "test" "test"
    , "All good" ~: combine testCompiler testCompiler
      baseContext ([Jmp], [Zjmp])
      ~?= Correct (baseContext, [Jmp, Zjmp])
    , "+> && <+" ~: (testCompiler +> testCompiler)
      baseContext ([Jmp] <+ [Zjmp])
      ~?= Correct (baseContext, [Jmp, Zjmp])
    , ".+" ~: (flip apply baseContext $
      (testCompiler, [Jmp])
      .+ (testCompiler, [Zjmp]))
      ~?=
      Correct (baseContext, [Jmp, Zjmp])
    , ".+ (a,b)" ~: (snd $ 
        (testCompiler, [Jmp])
      .+ (testCompiler, [Zjmp]))
      ~?=
      ([Jmp], [Zjmp])
    , "<@" ~: (flip apply baseContext $ 
       [Jmp] <@ (testCompiler, [Zjmp]))
      ~?= Correct (baseContext, [Jmp, Zjmp])
    , "@>" ~: (flip apply baseContext $ 
       (testCompiler, [Zjmp]) @> [Jmp])
      ~?= Correct (baseContext, [Zjmp, Jmp])
    , "rev" ~: (revCompiler (mapCompiler testCompiler))
      baseContext [[Jmp], [Zjmp], [Jmp], [Jmp]]
      ~?= Correct (baseContext, [Jmp, Jmp, Zjmp, Jmp])
    ]
  , "variables" ~:
    [ "insertVariable" ~: insertVariable baseContext ("x", 0)
      ~?= Context [("x", (0, 8))] 0 []
    , "getVariable - Error" ~: getVariable (Context [] 0 []) "x"
      ~?= Error ukVarErr "x"
    , "getVariable - Error" ~: getVariable (Context [("x", (0, 8))] 0 []) "x"
      ~?= Correct 0
    ]
  , "show context" ~: show (Context [] 0 ["test"])
    ~?= "Context {var = [], labelCount = 0, functionNames = [\"test\"]}"
  , "eq context" ~: (Context [("x", (0, 8))] 1 ["test"])
    == (Context [("x", (0, 8))] 1 ["test"])
    ~?= True
  , "getFuncName" ~: functionNames baseContext ~?= []
  , "compileMaybe" ~:
    [ "Nothing" ~: compileMaybe testCompiler baseContext Nothing
      ~?= Correct (baseContext,[])
    , "Just [Jmp]" ~: compileMaybe testCompiler baseContext (Just [Jmp])
      ~?= Correct (baseContext,[Jmp])
    ]
  ]
