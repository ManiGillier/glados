{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc arg parser
-}

module ArgParser (getMyArgs) where
import Options.Applicative


data Arguments = Arguments
    { i     :: String   -- Input files's name
    , o     :: String   -- Output file's name
    , llvm  :: Bool     -- Usage of LLVM
    , d     :: Bool     -- Debug
    }

aparser :: Parser Arguments
aparser = Arguments
    <$> strArgument (metavar "FILESNAME" <> help
        "List of the sourcefiles (.fr)" ) <*> strOption (short 'o' <> long
        "output" <> metavar "FILENAME" <> help "output's file name" <> value ""
        <> showDefault) <*>
        switch (long "llvm" <> help "Enable the use of LLVM")
        <*> switch (short 'd' <> long "debug" <> help "enable debug mode")

getOutput :: Arguments -> FilePath
getOutput (Arguments _ _ _ True) = "stdout"
getOutput (Arguments i [] _ _) = i
getOutput (Arguments _ o _ _) = o

getMyArgs :: IO ()
getMyArgs = goingNext =<< execParser opts
  where
    opts = info (aparser <**> helper)
      ( fullDesc
     <> progDesc
        "This program is a compiler for the Franc C programming language")

goingNext :: Arguments -> IO ()
goingNext (Arguments i o l d) =
    putStrLn $ "Input file(s) : " ++ i ++
    "; Output name : " ++ (getOutput (Arguments i o l d)) ++ "; LLVM usage : "
    ++ show l ++ "; Debug mode : " ++ show d
