{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc arg parser
-}

module ArgParser (aparser) where
import Control.Applicative

data Arguments = Arguments
{ o     :: Char     -- Output file's name
, llvm  :: String   -- Usage of LLVM
, d     :: Char     -- Debug
}

aparser :: Parser Arguments
aparser = Arguments
    <$> option auto
    (short 'o' 
    <> long "output"
    <> metavar "Char"
    <> help "O output's file name")
    <*> option auto
    (long "llvm"
        <> metavar String
    )
