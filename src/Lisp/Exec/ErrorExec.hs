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
                            callError,
                            condError)
                            where
argsError :: [a] -> String
argsError args = "*** ERROR : wrong number of argument of " 
    ++ show (length args)

nonProcedErrorStr :: String
nonProcedErrorStr = "*** ERROR : attempt to apply non-procedure"

nonProcedError :: Maybe String -> String
nonProcedError (Just x) = (nonProcedErrorStr ++ " " ++ x)
nonProcedError Nothing = nonProcedErrorStr 

notBoundError :: String -> String
notBoundError var = "*** ERROR : variable " ++ var ++ " is not bound"

callError ::Show a => String -> [a] -> String
callError fName args = 
    "in call (" ++ fName ++ concatMap ((" " ++) . show) args ++ ")"

condError :: String
condError = "*** ERROR : Invalid condition type"

procError :: String
procError = "#<procedure"
