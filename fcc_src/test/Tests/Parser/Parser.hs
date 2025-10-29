{-
-- EPITECH PROJECT, 2025
-- glados tests
-- File description:
-- Parser Utils
-}


module Tests.Parser.Parser (parserTest) where

import Test.HUnit ( (~:), (~?=), Test(TestList) )

import DataStruct.Ast.Ast as A
    ( Ast(Ast),
      BinaryOperator(Inferior, Superior, Add, Equals),
      Computable(Value, Operation, Variable),
      Condition(Condition),
      FunctionBodyContent(Invoke, Assign, Loop, If, Return, ShowStr,
                          Show),
      FunctionDef(Function),
      MainFunctionDef(Main),
      Operation(BinaryOperation) )
import Parser.Parser
    ( buildAst,
      extractBodyFunctionFromNextElse,
      extractBodyFunctionFromNextIf,
      extractConditionFromNextWhile,
      findMain,
      getMainCount,
      parseFunctions,
      parseMain,
      parseVariableDefinitions,
      skipTo,
      takeUntil,
      extractBodyFunctionFromNextWhile,
      getAllComputables,
      parseDisplay,
      parseAssign,
      parseWhile,
      parseReturn,
      isThereElse,
      skipComputables,
      parseInvoke,
      escapedCharacter,
      transformString,
      parseFunctionBody,
      convertReturnType,
      parseParams )

import DataStruct.Lexing as L (LexedData(Symbol, Number, Text, UnaryOperation, Operation, OpenParenthesis, ClosedParenthesis, VariableDeclaration, Parameter, LexedType, InvokeParameter, Assign, If, While, FuncDef, FuncType, ReturnType, WithParameters, WithVariables, Invoke, AssignResultTo, Display, DisplayNewLine, EndFunction, EndIf, EndWhile, Return, Then, Else, Returns), UnaryOperations (Negate), Operations (Add, Multiply, Equal, Inferior, Superior), LexedTypes (LInt, LBoolean, LVoid), VarValue(..), FuncTypes (Function, Main))
import qualified DataStruct.Ast.Variable as Var
import DataStruct.Ast.Variable (FuncParam(FuncParam))
import qualified DataStruct.Ast.Variable as A
import Error.MaybeError (MaybeError(Correct, Error))
import Error.ErrorList (alreadyDefFuncErr)


parserTest :: Test
parserTest = TestList
  [
    "takeUntil Test 1" ~: (takeUntil [Symbol "x",
        Symbol "y", Symbol "z", EndIf, Symbol "z"] EndIf)
        ~?= [Symbol "x", Symbol "y", Symbol "z"],
    "takeUntil Test 2" ~: (takeUntil [Symbol "x",
        Symbol "y", Symbol "z", EndIf, Symbol "z"] While)
        ~?= [],
    "takeUntil Test 3" ~: (takeUntil [Symbol "x",
        Symbol "y", Symbol "z", EndIf, Symbol "z", EndWhile] EndWhile)
        ~?= [Symbol "x", Symbol "y", Symbol "z", EndIf, Symbol "z"],
    "takeUntil Test 4" ~: (takeUntil [] EndIf) ~?= [],
    "getMainCount Test 1" ~: (getMainCount [FuncDef, FuncType L.Main,
        Display, Number 727, EndFunction]) ~?= 1,
    "getMainCount Test 2" ~: (getMainCount [FuncDef, FuncType L.Main,
        Display, Number 69, EndFunction, FuncDef, Symbol "x",
        Returns, L.LexedType LBoolean, Display, Number 10,
        EndFunction, FuncDef, FuncType L.Main, Display,
        Number 727, EndFunction
            ]) ~?= 2,
    "getMainCount Test 3" ~: (getMainCount [FuncDef, Symbol "x", Returns,
        L.LexedType LBoolean, Display, Number 727, EndFunction] ~?= 0),
    "findMain Test 1" ~: findMain [FuncDef, Symbol "y", Returns,
        L.LexedType LBoolean, Display, Number 727, EndFunction, FuncDef, FuncType L.Main,
        Display, Number 69, EndFunction, FuncDef, Symbol "x", Returns, L.LexedType LBoolean,
        Display, Number 10, EndFunction] ~?= [Display, Number 69],
    "findMain Test 2" ~: findMain [FuncDef, Symbol "y", Returns,
        L.LexedType LBoolean, Display, Number 727, EndFunction,
        FuncDef, Symbol "x", Returns, L.LexedType LBoolean,
        Display, Number 10, EndFunction] ~?= [],
    "parseVariableDefinitions Test 1" ~: (parseVariableDefinitions [FuncDef,
        WithVariables, VariableDeclaration "x" LInt (Int 69),
        VariableDeclaration "y" LBoolean (Int 1)])
        ~?= [Var.VariableDef "x" 69, Var.VariableDef "y" 1],
    "extractConditionFromNextWhile Test 1" ~:
        (extractConditionFromNextWhile [L.While, Number 1, Then, Display, Number 10, EndWhile])
        ~?= [Number 1],
    "extractConditionFromNextWhile Test 2" ~:
        (extractConditionFromNextWhile [Number 1, Then, Display, Number 10, EndWhile])
        ~?= [],
    "extractBodyFunctionFromNextWhile Test 1" ~:
        (extractBodyFunctionFromNextWhile [L.While, Number 1, Then, Display,
        Number 10, EndWhile]) ~?= [Display, Number 10],
    "extractBodyFunctionFromNextWhile Test 2" ~:
        (extractBodyFunctionFromNextWhile [Number 1, Display, Number 10, EndWhile])
        ~?= [],
    "extractBodyFunctionFromNextIf Test 1" ~:
        (extractBodyFunctionFromNextIf [L.If, Number 1, Then, Display, Number 10, EndIf])
        ~?= [Display, Number 10],
    "extractBodyFunctionFromNextIf Test 2" ~:
        (extractBodyFunctionFromNextIf [Number 1, Display, Number 10, EndIf])
        ~?= [],
    "extractBodyFunctionFromNextElse Test 1 " ~:
        (extractBodyFunctionFromNextElse [L.If, Number 1, Then, Display,
            Number 10, Else, Display, Number 727, EndIf]) ~?=
                [Display, Number 727],
    "extractBodyFunctionFromNextElse Test 2 " ~:
        (extractBodyFunctionFromNextElse [L.If, Number 1, Then, Display,
            Number 10, EndIf]) ~?=
                [],
    "skipTo Test 1" ~:
        (skipTo (Number 69) [Symbol "x", Symbol "y", Symbol "z",
            Number 69, Symbol "w"]) ~?=
                [Symbol "w"],
    "skipTo Test 2" ~:
        (skipTo (Number 727) [Symbol "x", Symbol "y", Symbol "z",
            Number 69, Symbol "w"]) ~?=
                [],
    "getAllComputables Test 1" ~:
        getAllComputables [Number 69, L.Operation L.Add, OpenParenthesis,
            Symbol "x", L.Operation L.Multiply, L.UnaryOperation L.Negate,
            Number 42, ClosedParenthesis, Then, Display, Symbol "x",
            EndFunction] ~?=
                [Number 69, L.Operation L.Add, OpenParenthesis,
            Symbol "x", L.Operation L.Multiply, L.UnaryOperation L.Negate,
            Number 42, ClosedParenthesis],
    "parseDisplay Test 1" ~:
        parseDisplay [Number 68, L.Operation L.Add, Number 1] ~?=
            A.Show (A.Operation
                (BinaryOperation A.Add
                    (A.Value 68) (A.Value 1))),
    "parseAssign Test 1" ~:
        parseAssign "meow" [Number 68, L.Operation L.Add, Number 1] ~?=
            A.Assign "meow" (A.Operation
                (BinaryOperation A.Add
                    (A.Value 68) (A.Value 1))),
    "parseWhile Test 1" ~:
        parseWhile [Number 727, L.Operation L.Superior, Symbol "x"]
            [Display, Symbol "w"] ~?=
        Loop (A.Condition (A.Operation
            (BinaryOperation A.Superior (A.Value 727) (Variable "x"))))
            [Show (Variable "w")],
    "parseReturn Test 1" ~:
        parseReturn [Number 68, L.Operation L.Add, Number 1] ~?=
            A.Return (A.Operation
                (BinaryOperation A.Add
                    (A.Value 68) (A.Value 1))),
    "isThereElse Test 1" ~:
        isThereElse [L.If, Number 1, Display, Number 69, EndIf] ~?= False,
    "isThereElse Test 2" ~:
        isThereElse [L.If, Number 1, Display, Number 69] ~?= False,
    "isThereElse Test 3" ~:
        isThereElse [L.If, Number 1, Display, Number 69, Else, Display,
            Number 727, EndIf] ~?= True,
    "skipComputables Test 1" ~:
        skipComputables [Number 69, L.Operation L.Add, OpenParenthesis,
            Symbol "x", L.Operation L.Multiply, L.UnaryOperation L.Negate,
            Number 42, ClosedParenthesis, Then, Display, Symbol "x",
            EndFunction] ~?=
                [Then, Display, Symbol "x", EndFunction],
    "parseInvoke Test 1" ~:
        parseInvoke "meow" Nothing [WithParameters, InvokeParameter [Number 727],
            InvokeParameter [Number 720, L.Operation L.Add, Number 7]]
            ~?= A.Invoke "meow" [A.Value 727,A.Operation
                (BinaryOperation A.Add (A.Value 720) (A.Value 7))] Nothing,
    "escapedCharacter Test 1" ~:
        escapedCharacter 'n' ~?= '\n',
    "escapedCharacter Test 2" ~:
        escapedCharacter 't' ~?= '\t',
    "escapedCharacter Test 3" ~:
        escapedCharacter '0' ~?= '\0',
    "escapedCharacter Test 4" ~:
        escapedCharacter 'r' ~?= '\r',
    "escapedCharacter Test 5" ~:
        escapedCharacter 'a' ~?= '\a',
    "escapedCharacter Test 6" ~:
        escapedCharacter 'w' ~?= 'w',
    "transformString Test 1" ~:
        transformString "salut\\t" ~?= "salut\t",
    "parseMain Test 1" ~:
        parseMain [FuncDef, FuncType L.Main, WithVariables, WithParameters,
            Display, Number 10,EndFunction] ~?= Just (A.Main [] [Show (A.Value 10)]),
    "parseMain Test 2" ~:
        parseMain [FuncDef, Symbol "x", WithVariables, WithParameters, Display,
            Number 10, EndFunction] ~?= Nothing,
    "convertReturnType Test 1" ~:
       convertReturnType <$> [LBoolean, LInt, LVoid] ~?= [True, True, False],
    "parseParams Test 1" ~:
        parseParams [WithParameters, Parameter "meow" LInt, Parameter "feur" LInt]
            ~?= [FuncParam "meow", FuncParam "feur"],
    "parseFunctions Test 1" ~:
        parseFunctions 
        [FuncDef,FuncType L.Function,Symbol "feur",
        ReturnType,LexedType LInt,
        WithParameters,Parameter "xd" LInt,
        WithVariables,VariableDeclaration "incroyable" LInt (Int 727),
            Display,Symbol "incroyable",
            L.If,Symbol "incroyable",L.Operation Equal,Number 0,Then,
                L.Assign,Symbol "incroyable",Number 69,
            Else,
                L.Assign,Symbol "incroyable",Number 69420,
            EndIf,
            While,Symbol "incroyable",L.Operation L.Inferior,Number 1000,Then,
                L.If,Symbol "incroyable",L.Operation L.Inferior,Number 100,Then,
                    Display, Text "try to stop the feeling",
                EndIf,
            EndWhile,
            L.Return,Number 51,
        EndFunction,
        FuncDef,FuncType L.Function,Symbol "meow",
        ReturnType,LexedType LInt,
        WithParameters,Parameter "lol" LInt,
        WithVariables,
            Display, Text "le glados c trop cool",
            DisplayNewLine,
            L.Invoke,Symbol "feur",
            L.Invoke,Symbol "feur",AssignResultTo,Symbol "lol",
        EndFunction,
        FuncDef,FuncType L.Main,
        WithVariables,VariableDeclaration "compteur" LInt (Int 49),
            L.Invoke,Symbol "feur",AssignResultTo,Symbol "compteur",WithParameters,InvokeParameter [Number 48],
            Display,Symbol "compteur",
            L.Return,OpenParenthesis,L.UnaryOperation L.Negate,Number 5,ClosedParenthesis,EndFunction] 
    
        ~?=
        
        [A.Function "feur" True [FuncParam "xd"] [A.VariableDef "incroyable" 727] [
            Show (Variable "incroyable"),
            A.If (A.Condition (A.Operation (BinaryOperation Equals (Variable "incroyable") (A.Value 0)))) [
                A.Assign "incroyable" (A.Value 69)
            ] (Just [
                A.Assign "incroyable" (A.Value 69420)]),
            Loop (A.Condition (A.Operation (BinaryOperation A.Inferior (Variable "incroyable") (A.Value 1000)))) [
                A.If (A.Condition (A.Operation (BinaryOperation A.Inferior (Variable "incroyable") (A.Value 100)))) [
                    ShowStr "try to stop the feeling"] Nothing],
                A.Return (A.Value 51)],
            A.Function "meow" True [FuncParam "lol"] [] [
                ShowStr "le glados c trop cool",
                Show (A.Value 10),
                A.Invoke "feur" [] Nothing,
                A.Invoke "feur" [] (Just "lol")]],
    "parseFunctionBody Test 1" ~:
        parseFunctionBody [EndFunction] ~?= [],
    "buildAst Test 1" ~:
        buildAst [] ~?= Correct (Ast Nothing []),
    "buildAst Test 2" ~:
        buildAst [FuncDef, FuncType L.Main, FuncDef, FuncType L.Main] ~?=
                Error alreadyDefFuncErr "main" 
  ]
