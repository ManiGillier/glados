{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- open a file
-}

module FileOpening.FileToBytecode (fileToByteCode) where

import qualified Data.ByteString as B
import Data.Word

fileToByteCode :: String -> IO [Word8]
fileToByteCode s = B.unpack <$> B.readFile s
