{--
-- EPITECH PROJECT, 2025
-- GLaDOS
-- File description:
-- Parser
--}

module Lisp.Parser.Parser (parseSExpr) where
import Lisp.DataStruct.SymbolicExpression as S ( SExpr(..) )
import Lisp.DataStruct.Ast as A ( Ast(..) )

parseLambdaArgs :: [SExpr] -> Maybe [String]
parseLambdaArgs [] = Just []
parseLambdaArgs (S.Symbol x:xs) = liftA2 (:) (Just x) (parseLambdaArgs xs)
parseLambdaArgs _ = Nothing

parseSExpr :: SExpr -> Maybe Ast
parseSExpr (S.List [S.Symbol "define", S.Symbol name, sContent])
  = A.Define name <$> parseSExpr sContent
parseSExpr (S.List [S.Symbol "lambda", S.List args, sContent])
  = A.Lambda <$> parseLambdaArgs args <*> parseSExpr sContent
parseSExpr (S.List [S.Symbol "define", S.List (S.Symbol name:args), sContent])
  = A.Define name <$> (A.Lambda <$> parseLambdaArgs args <*> parseSExpr sContent)
parseSExpr (S.List [S.Symbol "if", cond, true, false])
  = A.If <$> (parseSExpr cond) <*> (parseSExpr true) <*> (parseSExpr false)
parseSExpr (S.List (S.Symbol name:args))
  = A.Call name <$> mapM parseSExpr args
parseSExpr (S.List (ast:args))
  = A.Apply <$> parseSExpr ast <*> mapM parseSExpr args
parseSExpr (S.Symbol "#t") = Just $ A.Boolean True
parseSExpr (S.Symbol "#f") = Just $ A.Boolean False
parseSExpr (S.Symbol symbol) = Just $ A.Symbol symbol
parseSExpr (S.Value x) = Just $ A.Value x
parseSExpr _ = Nothing
