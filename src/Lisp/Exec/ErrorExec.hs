{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- ErrorExec 
-}

module Lisp.Exec.ErrorExec (argsError,
                            nonProcedError,
                            notBoundError,
                            procError,
                            ThrowsError) 
                            where

type ThrowsError = Either String

argsError :: [a] -> String
argsError args = "*** ERROR : wrong number of argument of " 
    ++ show (length args)

nonProcedErrorStr :: String
nonProcedErrorStr = "*** ERROR : attempt to apply non-procedure"

nonProcedError :: Maybe Int -> String
nonProcedError (Just x) = (nonProcedErrorStr ++ " " ++ show x)
nonProcedError Nothing = nonProcedErrorStr 

notBoundError :: String -> String
notBoundError var = "*** ERROR : variable " ++ var ++ " is not bound"

procError :: String
procError = "#<procedure"
