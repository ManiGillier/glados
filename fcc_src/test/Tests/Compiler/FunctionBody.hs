{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- compiler function body
-}

module Tests.Compiler.FunctionBody (functionBodyTest) where
import Test.HUnit (Test (TestList), (~:), (~?=))
import Compiler.FunctionBody (compileFuncBody)
import Compiler.Type (baseContext, Context (Context), f2c, f2cf)
import Error.MaybeError (MaybeError(..))
import DataStruct.Asm as Asm
import DataStruct.Ast.Ast as Ast
import Error.ErrorList (ukVarErr, returnValueInVoidFunction)
import Data.Int (Int64)

vi :: Int64 -> Ast.Computable
vi = Ast.Value

vi' :: Int64 -> Instruction
vi' = Asm.PushValue

v :: Ast.Computable
v = Ast.Value 42

v' :: Instruction
v' = Asm.PushValue 42

functionBodyTest :: Test
functionBodyTest = TestList
 [ "Return" ~: compileFuncBody (Context [] 0 (f2c ["test"]) [])
   [Return v] ~?= Correct ((Context [] 0 (f2c ["test"]) [])
                          , [v',PopToStackPtrRel (-8),Ret])
 , "Return base" ~: compileFuncBody baseContext
   [Return v] ~?= Correct (baseContext
                          , [v',PopToStackPtrRel (-8),Ret])
 , "Return on void" ~: compileFuncBody (Context [] 0 (f2cf ["test"]) [])
   [Return v] ~?= Error returnValueInVoidFunction "test"
 , "Show" ~: compileFuncBody baseContext
   [Show v] ~?= Correct (baseContext, [v',Aff])
 , "Invoke" ~: compileFuncBody baseContext
   [Invoke "f" [v] Nothing]
   ~?= Correct ((Context [] 0 [] $ f2cf ["f"]),
                [ v',PushValue 0, PushLabel "func_f", Call
                , PopEmpty, PopEmpty])
 , "Invoke with assign" ~: compileFuncBody
   (Context [("x", (0, 8))] 0 [] $ f2c ["a", "b"])
   [Invoke "f" [v] (Just "x")]
   ~?= Correct ((Context [("x", (0, 8))] 0 [] $ f2c ["f", "a", "b"]),
                [v',PushValue 0, PushLabel "func_f", Call
                , PopToStackPtrRel 0, PopEmpty])
 , "Invoke with assign incorrect var" ~:
   compileFuncBody baseContext
   [Invoke "f" [v] (Just "x")]
   ~?= Error ukVarErr "x"
 , "Invoke with args" ~: compileFuncBody baseContext
   [Invoke "f" [v, vi 41, vi 40] Nothing]
   ~?= Correct ((Context [] 0 [] $ f2cf ["f"]),
                [ vi' 40 -- last arg
                , vi' 41 -- middle arg
                , v' -- first arg
                , PushValue 0
                , PushLabel "func_f"
                , Call
                , PopEmpty, PopEmpty, PopEmpty, PopEmpty])
 , "if no else" ~: compileFuncBody baseContext
   [If (Condition v) [Return v] Nothing]
   ~?= Correct (Context [] 1 [] [],
                [ v', UpdateZFlag
                , PushLabel "if_0", Zjmp
                , v', PopToStackPtrRel (-8), Ret -- If
                , Label "if_0"])
 , "if else" ~: compileFuncBody baseContext
   [If (Condition v) [Return v] (Just [Return v])]
   ~?= Correct (Context [] 2 [] [],
                [ v', UpdateZFlag
                , PushLabel "if_0", Zjmp
                , v', PopToStackPtrRel (-8), Ret -- If
                , PushLabel "if_1", Jmp
                , Label "if_0"
                , v', PopToStackPtrRel (-8), Ret -- else
                , Label "if_1"])
 , "loop" ~: compileFuncBody baseContext
   [Loop (Condition v) [Return v]]
   ~?= Correct (Context [] 2 [] [],
                [ Label "while_0"
                , v', UpdateZFlag -- Cond calculus
                , PushLabel "while_1", Zjmp -- Cond effect
                , v', PopToStackPtrRel (-8), Ret -- Inside
                , PushLabel "while_0", Jmp
                , Label "while_1" -- End
                ])
 , "assign variable" ~: compileFuncBody (Context [("x", (0, 8))] 0 [] [])
   [Assign "x" v]
   ~?= Correct (Context [("x", (0, 8))] 0 [] [], [ v', PopToStackPtrRel 0])
 , "show str" ~: compileFuncBody (Context [] 0 [] [])
   [ShowStr "Hello, World!"]
   ~?= Correct (Context [] 0 [] [], [Affs "Hello, World!"])
 , "assign multiple variable" ~: compileFuncBody
   (Context [("x", (0, 8)),("y", (8, 8))] 0 [] [])
   [Assign "x" v, Assign "y" (Ast.Value 41)]
   ~?= Correct (Context [("x", (0, 8)),("y",(8,8))] 0 [] [],
                [ v', PopToStackPtrRel 0
                , Asm.PushValue 41, PopToStackPtrRel 8
                ])
 , "assign variable error" ~: compileFuncBody baseContext
   [Assign "x" v]
   ~?= Error ukVarErr "x"
 ]
