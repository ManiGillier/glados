{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- error management
-}

module Error.MaybeError ( ErrorType, MaybeError (..), fmap, pure, (<*>), (>>=)
             , printError
             , printMaybeError
             , toMaybeError
             , toMaybe
             , invertMaybe
             , (!<$>)
             , (!>>=)
             , (!>)
             , isMaybeErr
             , ifMaybeErr
             , execMaybeError
             ) where

import System.IO ( hPutStrLn, stderr )

import System.Exit (exitWith, ExitCode (..))

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

instance Foldable MaybeError where
  foldMap _ (Error _ _) = mempty
  foldMap f (Correct x) = f x

instance Traversable MaybeError where
  traverse _ (Error t m) = pure (Error t m)
  traverse f (Correct a) = Correct <$> f a

toMaybeError :: Maybe a -> (ErrorType,String) -> MaybeError a
toMaybeError Nothing (err_type,err_str) = Error err_type err_str
toMaybeError (Just result) _ = Correct result

infixl 5 !>
(!>) :: Maybe a -> (ErrorType,String) -> MaybeError a
a !> e = toMaybeError a e

infixl 5 !>>=
(!>>=) :: Maybe a -> (a -> MaybeError b) -> ((ErrorType,String) -> MaybeError b)
Nothing !>>= _ = \(e,m) -> Error e m
(Just a) !>>= f = \_ -> f a

infixl 5 !<$>
(!<$>) :: (a -> b) -> Maybe a -> ((ErrorType,String) -> MaybeError b)
_ !<$> Nothing = \(e,m) -> Error e m
f !<$> (Just a) = \_ -> Correct $ f a

printError :: MaybeError a -> IO ()
printError (Error t c) = hPutStrLn stderr (t ++ ": " ++ c)
  >> exitWith (ExitFailure 84)
printError _ = return ()

printMaybeError :: (a -> IO ()) -> MaybeError a -> IO ()
printMaybeError _ (Error t c) = hPutStrLn stderr (t ++ ": " ++ c)
  >> exitWith (ExitFailure 84)
printMaybeError f (Correct a) = f a

toMaybe :: MaybeError a -> Maybe a
toMaybe (Correct x) = Just x
toMaybe (Error _ _) = Nothing

invertMaybe :: Maybe (MaybeError a) -> MaybeError (Maybe a)
invertMaybe Nothing = Correct Nothing
invertMaybe (Just (Correct a)) = Correct (Just a)
invertMaybe (Just (Error x y)) = Error x y

isMaybeErr :: MaybeError a -> (a -> Bool) -> Bool
isMaybeErr (Error _ _) _ = False
isMaybeErr (Correct a) f = f a

ifMaybeErr :: MaybeError a -> (a -> b) -> b -> b
ifMaybeErr (Error _ _) _ b = b
ifMaybeErr (Correct a) f _ = f a

execMaybeError :: MaybeError (IO ()) -> IO ()
execMaybeError (Correct a) = a
execMaybeError e = printError e
