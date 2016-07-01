definition module ABC.Nodes

from ABC.Def import ::ArgNr, ::Arity, ::NodeId, ::InstrId, ::Args, ::DescId, ::NrArgs
from ABC.BStack import ::Basic

:: Node = Node DescId InstrId Args
        | Basic DescId InstrId Basic
        | Empty

n_arg       :: Node ArgNr Arity -> NodeId
n_args      :: Node Arity -> [NodeId]
n_arity     :: Node -> Arity
n_B         :: Node -> Bool
n_I         :: Node -> Int
n_copy      :: Node Node -> Node
n_descid    :: Node -> DescId
n_entry     :: Node -> InstrId
n_eq_arity  :: Node Arity -> Bool
n_eq_B      :: Node Bool -> Bool
n_eq_descid :: Node DescId -> Bool
n_eq_I      :: Node Int -> Bool
n_eq_symbol :: Node Node -> Bool
n_fill      :: DescId InstrId Args Node -> Node
n_fillB     :: DescId InstrId Bool Node -> Node
n_fillI     :: DescId InstrId Int Node -> Node
n_nargs     :: Node NrArgs Arity -> [NodeId]
n_setentry  :: InstrId Node -> Node
