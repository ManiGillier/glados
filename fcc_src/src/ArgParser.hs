{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc arg parser
-}

module ArgParser (getMyArgs, Arguments (..)) where
import Options.Applicative
    ( (<**>),
      Alternative(some),
      fullDesc,
      help,
      info,
      long,
      metavar,
      progDesc,
      short,
      showDefault,
      strArgument,
      strOption,
      switch,
      value,
      execParser,
      helper,
      Parser, failureCode )
import Error.MaybeError (MaybeError (Correct, Error))
import Error.ErrorList (unsupportedLanguage)
import Data.Functor ((<&>))

data Arguments = Arguments
    { input     :: ![String] -- Input files's name
    , output    :: !String   -- Output file's name
    , larousse  :: !Bool     -- Usage of larousse
    , debug     :: !Bool     -- Debug
    } deriving (Show, Eq)

aparser :: Parser Arguments
aparser = changeOutput <$> (Arguments
    <$> some (strArgument (metavar "FILESNAME" <> help
        "List of the sourcefiles (.fr)" )) <*> strOption (short 'o' <> long
        "output" <> metavar "FILENAME" <> help "output's file name" <> value ""
        <> showDefault) <*> fmap not (switch
        (short 'n' <> long "no-larousse" <> help "Disable the Larousse"))
        <*> switch (short 'd' <> long "debug" <> help "enable debug mode"))

getOutput :: Arguments -> FilePath
getOutput (Arguments _ _ _ True) = "/dev/stdout"
getOutput (Arguments (_:_) "" _ _) = "a.fcp"
getOutput (Arguments _ o _ _) = o

changeOutput :: Arguments -> Arguments
changeOutput args = args { output = getOutput args }

endWith :: Eq a => [a] -> [a] -> Bool
endWith [] _ = True
endWith (l:ls) (l':ls')
  | l:ls == l':ls' = True
  | otherwise = endWith (l:ls) ls'
endWith _ [] = False

manageArgErrors :: Arguments -> MaybeError Arguments
manageArgErrors a@(Arguments [] _ _ _) = Correct a
manageArgErrors a@(Arguments (x:xs) _ _ _)
  | endWith ".fr" x = manageArgErrors (a { input=xs }) <&> return a
  | otherwise = Error unsupportedLanguage x

getMyArgs :: IO (MaybeError Arguments)
getMyArgs = (execParser $ info (aparser <**> helper) $
  fullDesc <> progDesc
  "This program is a compiler for the Franc C programming language"
  <> failureCode 84) <&> manageArgErrors
