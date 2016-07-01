implementation module ABC.AStack

import StdEnv

import ABC.Def
import ABC.Misc

:: AStack :== [NodeId]

as_get    :: ASrc AStack -> NodeId
as_get _ []    = abortn "as_get: index too large"
as_get 0 [n:_] = n
as_get i [_:s] = as_get (i-1) s

as_init   :: AStack
as_init = []

as_popn   :: NrArgs AStack -> AStack
as_popn 0 s     = s
as_popn _ []    = abortn "as_popn: popping too many elements"
as_popn i [_:s] = as_popn (i-1) s

as_push   :: NodeId AStack -> AStack
as_push n s = [n:s]

as_pushn  :: [NodeId] AStack -> AStack
as_pushn is s = is ++ s

as_topn   :: NrArgs AStack -> [NodeId]
as_topn i s = topn [] i s
where
	topn :: [NodeId] NrArgs AStack -> [NodeId]
	topn ns 0 _     = ns
	topn _ i []     = abortn "as_topn: taking too many elements"
	topn ns i [n:s] = topn (ns ++ [n]) (i-1) s

as_update :: ADst NodeId AStack -> AStack
as_update 0 n [_:s] = [n:s]
as_update _ _ []    = abortn "as_update: index too large"
as_update i n [m:s] = [m:as_update (i-1) n s]
