definition module ABC.Misc

from StdOverloaded import class toString

abortn :: String -> a

(<+) infixl 5  :: a b -> String | toString a & toString b
(<++) infixl 5 :: a (g, [b]) -> String | toString a & toString b & toString g
