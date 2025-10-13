{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- compiler function body
-}

module Tests.Compiler.FunctionBody (functionBodyTest) where
import Test.HUnit (Test (TestList), (~:), (~?=))
import Compiler.FunctionBody (compileFuncBody)
import Compiler.Type (baseContext, Context (Context))
import Error.MaybeError (MaybeError(..))
import DataStruct.Asm as Asm
import DataStruct.Ast.Ast as Ast
import DataStruct.Ast.Variable as Var
import Error.ErrorList (ukVarErr)

v :: Ast.Computable
v = Ast.Value $ Var.Int 42

v' :: Instruction
v' = Asm.PushValue 42

functionBodyTest :: Test
functionBodyTest = TestList
 [ "Return" ~: compileFuncBody baseContext
   [Return v] ~?= Correct (baseContext, [v',Ret])
 , "Show" ~: compileFuncBody baseContext
   [Show v] ~?= Correct (baseContext, [v',Aff])
 , "Invoke" ~: compileFuncBody baseContext
   [Invoke "f" [v]]
   ~?= Correct (baseContext, [v',PushLabel "func_f", Call])
 , "if no else" ~: compileFuncBody baseContext
   [If (Condition v) [Return v] Nothing]
   ~?= Correct (Context [] 1 [],
                [ v', UpdateZFlag
                , PushLabel "if_0", Zjmp
                , v', Ret -- If
                , Label "if_0"])
 , "if else" ~: compileFuncBody baseContext
   [If (Condition v) [Return v] (Just [Return v])]
   ~?= Correct (Context [] 2 [],
                [ v', UpdateZFlag
                , PushLabel "if_0", Zjmp
                , v', Ret -- If
                , PushLabel "if_1", Jmp
                , Label "if_0"
                , v', Ret -- Else
                , Label "if_1"])
 , "loop" ~: compileFuncBody baseContext
   [Loop (Condition v) [Return v]]
   ~?= Correct (Context [] 2 [],
                [ Label "while_0"
                , v', UpdateZFlag -- Cond calculus
                , PushLabel "while_1", Zjmp -- Cond effect
                , v', Ret -- Inside
                , PushLabel "while_0", Jmp
                , Label "while_1" -- End
                ])
 , "assign variable" ~: compileFuncBody (Context [("x", (0, 8))] 0 [])
   [Assign "x" v]
   ~?= Correct (Context [("x", (0, 8))] 0 [], [ v', PopToStackPtrRel 0])
 , "assign variable error" ~: compileFuncBody baseContext
   [Assign "x" v]
   ~?= Error ukVarErr "x"
 ]
