implementation module ABC.Misc

import StdEnv

abortn :: String -> a
abortn s = abort (s +++ "\n")
