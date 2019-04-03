module Main where

import Foracosta

main :: IO ()
main = do
  putStr "> "
  getLine >>= run >> main
