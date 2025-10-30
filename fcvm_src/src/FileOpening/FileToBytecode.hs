{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- open a file
-}

module FileOpening.FileToBytecode (fileToByteCode) where

import qualified Data.ByteString as B
import Data.Word
import Error.MaybeError (MaybeError (..))
import Error.ErrorList (fileErr)
import Control.Exception (try, IOException)
import Data.Functor ((<&>))

fileToByteCode :: String -> IO (MaybeError [Word8])
fileToByteCode s = r <&>
  \r' -> case r' of
    Left _ -> Error fileErr s
    Right x -> Correct x
  where r = try (B.unpack <$> B.readFile s) :: IO (Either IOException [Word8])
