
module Ta
    ( Returnable()
    , Operation()
    ) where

data Returnable =
  Value String
  | Operation Operation

data Operation = Operator [Returnable]
