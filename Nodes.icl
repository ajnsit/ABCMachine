implementation module ABC.Nodes

import StdEnv

import ABC.Machine
import ABC.Misc

n_arg       :: Node ArgNr Arity -> NodeId
n_arg n i a
| a >= i    = (n_args n a)!!i
| otherwise = abortn "n_arg: index greater than arity"

n_args      :: Node Arity -> [NodeId]
n_args (Node _ _ args) a
| a == length args = args
| otherwise        = abortn "n_args: incorrect arity"
n_args _ _         = abortn "n_args: no arguments in node"

n_arity     :: Node -> Arity
n_arity (Basic _ _ _)   = 0
n_arity (Node _ _ args) = length args
n_arity Empty           = abortn "n_arity: arity on Empty not defined"

n_B         :: Node -> Bool
n_B (Basic _ _ (Bool b)) = b
n_B _                    = abortn "n_B: no boolean in node"

n_I         :: Node -> Int
n_I (Basic _ _ (Int i)) = i
n_I _                   = abortn "n_I: no integer in node"

n_copy      :: Node Node -> Node
n_copy new old = new

n_descid    :: Node -> DescId
n_descid (Node i _ _)  = i
n_descid (Basic i _ _) = i
n_descid Empty         = abortn "n_descid: no descid in node"

n_entry     :: Node -> InstrId
n_entry (Node _ e _)  = e
n_entry (Basic _ e _) = e
n_entry Empty         = abortn "n_entry: no entry in node"

n_eq_arity  :: Node Arity -> Bool
n_eq_arity n a = n_arity n == a

n_eq_B      :: Node Bool -> Bool
n_eq_B n b = n_B n == b

n_eq_descid :: Node DescId -> Bool
n_eq_descid n i = n_descid n == i

n_eq_I      :: Node Int -> Bool
n_eq_I n i = n_I n == i

n_eq_symbol :: Node Node -> Bool
n_eq_symbol (Node i1 _ _)   (Node i2 _ _)   = i1 == i2
n_eq_symbol (Basic i1 _ b1) (Basic i2 _ b2) = i1 == i2 && b1 == b2
n_eq_symbol _               _               = False

n_fill      :: DescId InstrId Args Node -> Node
n_fill d i a _ = Node d i a

n_fillB     :: DescId InstrId Bool Node -> Node
n_fillB d e b _ = Basic d e (Bool b)

n_fillI     :: DescId InstrId Int Node -> Node
n_fillI d e i _ = Basic d e (Int i)

n_nargs     :: Node NrArgs Arity -> [NodeId]
n_nargs n i a = take i (n_args n a)

n_setentry  :: InstrId Node -> Node
n_setentry e (Node d _ a)  = Node d e a
n_setentry e (Basic d _ b) = Basic d e b
n_setentry _ Empty         = abortn "n_setentry: Empty node"
