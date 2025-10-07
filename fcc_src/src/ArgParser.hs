{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc arg parser
-}

module ArgParser (aparser) where
import Control.Applicative
import Options.Applicative

data Arguments = Arguments
    { i     :: String   -- Input files's name
    , o     :: String   -- Output file's name
    , llvm  :: Bool     -- Usage of LLVM
    , d     :: Bool     -- Debug
    }

aparser :: Parser Arguments
aparser = Arguments
    <?> option auto
    (metavar "FILESNAME"
        <> help "List of the sourcefiles (.fr)"
    )
    <*> option auto
    (short 'o'
    <> long "output"
    <> metavar "FILENAME"
    <> help "output's file name")
    <*> option auto
    (long "llvm"
        <> help "Enable the use of LLVM")
    <*> option auto
    (short 'd'
        <> long "debug"
        <> help "enable debug mode")

getOutput :: Arguments -> FilePath
getOutput (Arguments i o llvm d)
    | _ _ _ True = "stdout"
    | otherwise = fromMaybe i o

getArgs :: IO ()
getArgs = getOutput =<< execParser opts
  where
    opts = info (aparser <**> helper)
      ( fullDesc
     <> progDesc "This program is a compiler for the Franc C programming language")

goingNext :: Arguments -> IO ()
goingNext = putStrLn ("Input file(s) : " ++ (Arguments i) ++ "; Output name : " ++ (getOutput Arguments) ++ "LLVM usage : " ++ (Arguments llvm) ++ "Debug mode : " ++ (Arguments d))
