{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- example ast
-}

module Examples.Ast (exampleAst) where

import DataStruct.Ast.Ast as Ast
import DataStruct.Ast.Variable as V

exampleAst :: Ast
exampleAst = Ast
  -- MAIN --
  (Just $ Main
   -- Main Variables
   []
   -- Main Content
   [ Invoke "foo" [Ast.Value 42, Ast.Value 1] Nothing
   , Invoke "foo"
     [ Ast.Operation $ Ast.BinaryOperation Ast.Add
       (Ast.Value 48)
       (Ast.Value 5)
     , Ast.Value 2
     ] Nothing
   , Invoke "bar" [Ast.Value 5] Nothing
   ])
  -- OTHER FUNCS --
  [ Ast.Function "foo" False
    -- FOO Params
    [ V.FuncParam "a", V.FuncParam "b" ]
    -- FOO Variables
    [ VariableDef "c" 0 ]
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
        (Ast.Value 1)
    , Show $ Ast.Variable "c"
    ]
  , Ast.Function "bar" False
    -- BAR PARAMS
    [V.FuncParam "a"]
    -- BAR VARIABLES
    [VariableDef "b" 0]
    -- BAR BODY
    [ Assign "b" $ Ast.Value 48
    , Assign "b" $ Ast.Operation
      $ Ast.BinaryOperation
        Ast.Add
        (Ast.Variable "a")
        (Ast.Variable "b")
    , Invoke "foo" [ Ast.Variable "b", Ast.Value (-1) ] Nothing
    ]
  ]
