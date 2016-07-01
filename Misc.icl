implementation module ABC.Misc

import StdEnv

abortn :: String -> a
abortn s = abort (s +++ "\n")

(<+) infixl 5 :: a b -> String | toString a & toString b
(<+) a b = toString a +++ toString b

(<++) infixl 5 :: a (g, [b]) -> String | toString a & toString b & toString g
(<++) a (g,xs) = a <+ printersperse g xs

printersperse :: a [b] -> String | toString a & toString b
printersperse g []     = ""
printersperse g [x]    = toString x
printersperse g [x:xs] = x <+ g <++ (g, xs)
