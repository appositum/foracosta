{-# language ViewPatterns #-}

module Foracosta where

import Data.Void
import Stack
import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

type Parser = Parsec Void String

tokenize :: Parser a -> Parser a
tokenize p = space *> p <* space

integer :: Parser Integer
integer = tokenize L.decimal

symbolic :: Char -> Parser Char
symbolic = tokenize . char

data Op = Add | Mul
  deriving (Eq, Show)

data AST = Val Integer | App Op [AST]
  deriving (Eq, Show)

parseOp :: Parser Op
parseOp = do
  op <- char '+' <|> char '*'
  pure $
    case op of
      '+' -> Add
      '*' -> Mul

parseAST :: Parser AST
parseAST = do
  values <- some integer
  op <- parseOp
  pure $ App op (map Val values)

eval :: AST -> Integer
eval (Val n) = n
eval (App op xs) = foldr1 (operation op) (eval <$> xs) where
  operation :: Op -> (Integer -> Integer -> Integer)
  operation Add = (+)
  operation Mul = (*)

readAST :: String -> Either (ParseErrorBundle String Void) AST
readAST = parse parseAST mempty

run :: String -> IO ()
run (readAST -> Left e) = putStr $ errorBundlePretty e
run (readAST -> Right a) = print $ eval a
