definition module ABC.AStack

from ABC.Def import ::NodeId, ::NrArgs

:: ASrc    :== Int
:: ADst    :== Int
:: AStack (:== [NodeId])

as_get    :: ASrc AStack -> NodeId
as_init   :: AStack
as_popn   :: NrArgs AStack -> AStack
as_push   :: NodeId AStack -> AStack
as_pushn  :: [NodeId] AStack -> AStack
as_topn   :: NrArgs AStack -> [NodeId]
as_update :: ADst NodeId AStack -> AStack
