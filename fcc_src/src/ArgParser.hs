{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc arg parser
-}

module ArgParser (aparser) where
import Options.Applicative


data Arguments = Arguments
    { i     :: String   -- Input files's name
    , o     :: String   -- Output file's name
    , llvm  :: Bool     -- Usage of LLVM
    , d     :: Bool     -- Debug
    }

aparser :: Parser Arguments
aparser = Arguments
    <$> option auto
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
getOutput (Arguments _ _ _ True) = "stdout"
getOutput (Arguments i [] _ _) = i
getOutput (Arguments _ o _ _) = o

getArgs :: IO ()
getArgs = goingNext =<< execParser opts
  where
    opts = info (aparser <**> helper)
      ( fullDesc
     <> progDesc "This program is a compiler for the Franc C programming language")

goingNext :: Arguments -> IO ()
goingNext (Arguments i o l d) = putStrLn $ "Input file(s) : " ++ i ++ "; Output name : " ++ o ++ "; LLVM usage : " ++ show l ++ "; Debug mode : " ++ show d
