definition module ABC.Instructions

from ABC.Def import ::NrArgs, ::State, ::DescId, ::Arity, ::InstrId, ::ArgNr
from ABC.AStack import ::ASrc, ::ADst
from ABC.BStack import ::BSrc, ::BDst

add_args       :: ASrc NrArgs ADst State -> State
create         :: State -> State
del_args       :: ASrc NrArgs ADst State -> State
dump           :: String State -> State
eq_desc        :: DescId ASrc State -> State
eq_desc_arity  :: DescId Arity ASrc State -> State
eq_symbol      :: ASrc ASrc State -> State
eqB            :: State -> State
eqB_a          :: Bool ASrc State -> State
eqB_b          :: Bool BSrc State -> State
eqI            :: State -> State
eqI_a          :: Int ASrc State -> State
eqI_b          :: Int BSrc State -> State
fill           :: DescId NrArgs InstrId ADst State -> State
fill_a         :: ASrc ADst State -> State
fillB          :: Bool ADst State -> State
fillB_b        :: BSrc ADst State -> State
fillI          :: Int ADst State -> State
fillI_b        :: BSrc ADst State -> State
get_desc_arity :: ASrc State -> State
get_node_arity :: ASrc State -> State
halt           :: State -> State
jmp            :: InstrId State -> State
jmp_eval       :: State -> State
jmp_false      :: InstrId State -> State
jmp_true       :: InstrId State -> State
jsr            :: InstrId State -> State
jsr_eval       :: State -> State
no_op          :: State -> State
pop_a          :: NrArgs State -> State
pop_b          :: NrArgs State -> State
print          :: String State -> State
print_symbol   :: ASrc State -> State
push_a         :: ASrc State -> State
push_ap_entry  :: ASrc State -> State
push_arg       :: ASrc Arity ArgNr State -> State
push_arg_b     :: ASrc State -> State
push_args      :: ASrc Arity NrArgs State -> State
push_args_b    :: ASrc State -> State
push_b         :: BSrc State -> State
pushB          :: Bool State -> State
pushB_a        :: ASrc State -> State
pushI          :: Int State -> State
pushI_a        :: ASrc State -> State
repl_args      :: Arity NrArgs State -> State
repl_args_b    :: State -> State
rtn            :: State -> State
set_entry      :: InstrId ADst State -> State
update_a       :: ASrc ADst State -> State
update_b       :: BSrc BDst State -> State

addI :: State -> State
decI :: State -> State
gtI  :: State -> State
incI :: State -> State
ltI  :: State -> State
mulI :: State -> State
subI :: State -> State
