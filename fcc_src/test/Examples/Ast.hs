{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- example ast
-}

module Examples.Ast (exampleAst) where

import DataStruct.Ast.Ast as Ast
import DataStruct.Ast.Type as T
import DataStruct.Ast.Variable as V

exampleAst :: Ast
exampleAst = Ast
  -- MAIN --
  (Just $ Main
   -- Main Variables
   []
   -- Main Content
   [ Invoke "foo" [Ast.Value $ V.Int 42, Ast.Value $ V.Int 1]
   , Invoke "foo"
     [ Ast.Operation $ Ast.BinaryOperation Ast.Add
       (Ast.Value $ V.Int 48)
       (Ast.Value $ V.Int 5)
     , Ast.Value $ V.Int 2
     ]
   , Invoke "bar" [Ast.Value $ V.Int 5]
   ])
  -- OTHER FUNCS --
  [ Ast.Function "foo" V.Void
    -- FOO Params
    [ V.FuncParam "a" T.Int, V.FuncParam "b" T.Int ]
    -- FOO Variables
    [ VariableDef "c" T.Int $ V.Int 0 ]
    -- FOO Content
    [ Assign "c" $ Ast.Operation
      $ Ast.BinaryOperation
        Ast.Add
        (Ast.Variable "a")
        (Ast.Variable "b")
    , Assign "c" $ Ast.Operation
      $ Ast.BinaryOperation
        Ast.Add
        (Ast.Variable "c")
        (Ast.Value $ V.Int 1)
    , Show $ Ast.Variable "c"
    ]
  , Ast.Function "bar" V.Void
    -- BAR PARAMS
    [V.FuncParam "a" T.Int]
    -- BAR VARIABLES
    [VariableDef "b" T.Int $ V.Int 0]
    -- BAR BODY
    [ Assign "b" $ Ast.Value $ V.Int 48
    , Assign "b" $ Ast.Operation
      $ Ast.BinaryOperation
        Ast.Add
        (Ast.Variable "a")
        (Ast.Variable "b")
    , Invoke "foo" [ Ast.Variable "b", Ast.Value $ V.Int (-1) ]
    ]
  ]
