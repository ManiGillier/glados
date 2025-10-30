{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Larousse getter
-}

module LarousseGetter (getLarousse) where

import Control.Exception (IOException, try)
import Control.Monad (filterM)

import System.Directory ( doesFileExist, listDirectory )
import System.FilePath ( takeExtension )

libPath :: String
libPath = "./larousse"

filterFrFiles :: [FilePath] -> [FilePath]
filterFrFiles = filter $ (== ".fr") . takeExtension

getDirFiles :: FilePath -> IO [FilePath]
getDirFiles file =
  (\ds' -> case ds' of
             Left _ -> [] -- Empty dir list if dir is not found
             Right x -> map (\s -> file ++ "/" ++ s) x
  ) <$> ds
  where ds = try $ listDirectory file :: IO (Either IOException [FilePath])
 
getSubDirs :: [FilePath] -> IO [FilePath]
getSubDirs ds = fmap concat $ mapM getDirFiles ds

getDirList :: IO [FilePath]
getDirList = getDirFiles libPath

filterFiles :: [FilePath] -> IO [FilePath]
filterFiles = filterM doesFileExist

getAllFilesInLarousseDir :: IO [FilePath]
getAllFilesInLarousseDir = getDirList >>= getSubDirs

getLarousse :: IO [FilePath]
getLarousse = getAllFilesInLarousseDir
  >>= filterFiles <$> filterFrFiles
