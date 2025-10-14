{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc arg parser
-}

module ArgParser (getMyArgs, debugArgs, Arguments (..)) where
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
      Parser )

data Arguments = Arguments
    { input     :: ![String] -- Input files's name
    , output    :: !String   -- Output file's name
    , llvm      :: !Bool     -- Usage of LLVM
    , debug     :: !Bool     -- Debug
    }

aparser :: Parser Arguments
aparser = Arguments
    <$> some (strArgument (metavar "FILESNAME" <> help
        "List of the sourcefiles (.fr)" )) <*> strOption (short 'o' <> long
        "output" <> metavar "FILENAME" <> help "output's file name" <> value ""
        <> showDefault) <*>
        switch (long "llvm" <> help "Enable the use of LLVM")
        <*> switch (short 'd' <> long "debug" <> help "enable debug mode")

getOutput :: Arguments -> FilePath
getOutput (Arguments _ _ _ True) = "stdout"
getOutput (Arguments (i:_) [] _ _) = i
getOutput (Arguments _ o _ _) = o

getMyArgs :: IO Arguments
getMyArgs = execParser $ info (aparser <**> helper) $
  fullDesc <> progDesc
  "This program is a compiler for the Franc C programming language"

debugArgs :: Arguments -> IO ()
debugArgs (Arguments i o l d) =
    putStrLn $ "Input file(s) : " ++ (concat i)  ++
    "; Output name : " ++ (getOutput (Arguments i o l d)) ++ "; LLVM usage : "
    ++ show l ++ "; Debug mode : " ++ show d
