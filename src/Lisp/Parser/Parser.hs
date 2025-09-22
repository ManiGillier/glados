{--
-- EPITECH PROJECT, 2025
-- GLaDOS
-- File description:
-- Parser
--}

module Lisp.Parser.Parser (parseSExpr) where
import Lisp.DataStruct.SymbolicExpression as S ( SExpr(..) )
import Lisp.DataStruct.Ast as A ( Ast(..) )
import Error.MaybeError (MaybeError (..))
import Error.ErrorList (lambdaArgError, invalidRestrictedKeywordUse, parsingError)

parseLambdaArgs :: [SExpr] -> MaybeError [String]
parseLambdaArgs [] = Correct []
parseLambdaArgs (S.Symbol x:xs) = liftA2 (:) (Correct x) (parseLambdaArgs xs)
parseLambdaArgs (S.Value value:_) = Error lambdaArgError $ "Unexpected value " ++ show value
  ++ ". Expected symbol."
parseLambdaArgs (S.List _:_) = Error lambdaArgError $ "Unexpected list. Expected symbol."

restrictedKeyword :: [String]
restrictedKeyword = [ "define", "lambda", "if", "#t", "#f" ]

parseSExpr :: SExpr -> MaybeError Ast
parseSExpr (S.List [S.Symbol "define", S.Symbol name, sContent])
  | name `elem` restrictedKeyword = Error invalidRestrictedKeywordUse name
  |  otherwise = A.Define name <$> parseSExpr sContent
parseSExpr (S.List [S.Symbol "define", S.List (S.Symbol name:args), sContent])
  | name `elem` restrictedKeyword = Error invalidRestrictedKeywordUse name
  | otherwise = A.Define name <$> (A.Lambda <$> parseLambdaArgs args <*> parseSExpr sContent)
parseSExpr (S.List (S.Symbol "define":_))
  = Error invalidRestrictedKeywordUse "Usage: (define {<name> | (<name> <args>)} <query>)"
parseSExpr (S.List [S.Symbol "lambda", S.List args, sContent])
  = A.Lambda <$> parseLambdaArgs args <*> parseSExpr sContent
parseSExpr (S.List (S.Symbol "lambda":_))
  = Error invalidRestrictedKeywordUse "Usage: (lambda (<params>) <body>)"
parseSExpr (S.List [S.Symbol "if", cond, true, false])
  = A.If <$> (parseSExpr cond) <*> (parseSExpr true) <*> (parseSExpr false)
parseSExpr (S.List (S.Symbol "if":_))
  = Error invalidRestrictedKeywordUse "Usage: (if <cond> <if-#t> <if-#f>)"
parseSExpr (S.List (S.Symbol name:args))
  = A.Call name <$> mapM parseSExpr args
parseSExpr (S.List (ast:args))
  = A.Apply <$> parseSExpr ast <*> mapM parseSExpr args
parseSExpr (S.List [])
  = Error parsingError "Empty list."
parseSExpr (S.Symbol "#t") = Correct $ A.Boolean True
parseSExpr (S.Symbol "#f") = Correct $ A.Boolean False
parseSExpr (S.Symbol symbol) = Correct $ A.Symbol symbol
parseSExpr (S.Value x) = Correct $ A.Value x
