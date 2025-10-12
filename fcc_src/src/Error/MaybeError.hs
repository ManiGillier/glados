{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- error management
-}

module Error.MaybeError ( ErrorType, MaybeError (..), fmap, pure, (<*>), (>>=)
             , printError
             , toMaybeError
             , toMaybe
             , invertMaybe ) where

import System.IO ( hPutStrLn, stderr )

type ErrorType = String

data MaybeError a = Error !ErrorType !String | Correct !a
  deriving (Eq)

instance Show a => Show (MaybeError a) where
  show (Correct x) = show x
  show (Error t "") = t
  show (Error t s) = t ++ ": " ++ s

instance Functor MaybeError where
  fmap f (Correct x) = Correct (f x)
  fmap _ (Error errorType str) = Error errorType str

instance Applicative MaybeError where
  pure = Correct

  (<*>) (Error t s) _ = Error t s
  (<*>) _ (Error t s) = Error t s
  (<*>) (Correct f) (Correct x) = Correct (f x)

instance Monad MaybeError where
  (>>=) (Correct x) f = f x
  (>>=) (Error errorType str) _ = Error errorType str

toMaybeError :: Maybe a -> (ErrorType,String) -> MaybeError a
toMaybeError Nothing (err_type,err_str) = Error err_type err_str
toMaybeError (Just result) _ = Correct result

printError :: MaybeError a -> IO ()
printError (Error t c) = hPutStrLn stderr (t ++ ": " ++ c)
printError _ = return ()

toMaybe :: MaybeError a -> Maybe a
toMaybe (Correct x) = Just x
toMaybe (Error _ _) = Nothing

invertMaybe :: Maybe (MaybeError a) -> MaybeError (Maybe a)
invertMaybe Nothing = Correct Nothing
invertMaybe (Just (Correct a)) = Correct (Just a)
invertMaybe (Just (Error x y)) = Error x y
