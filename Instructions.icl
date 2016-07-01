implementation module ABC.Instructions

import StdEnv

import ABC.Machine
import ABC.Misc

int_desc  :== 0
bool_desc :== 1
rnf_entry :== 1

add_args       :: ASrc NrArgs ADst State -> State
add_args a_src nr_args a_dst st=:{astack,graphstore}
	= {st & astack=astack`, graphstore=graphstore`}
where
	astack`     = as_popn nr_args astack
	graphstore` = gs_update dstid (n_fill descid entry newargs) graphstore
	dstid       = as_get a_dst astack
	srcid       = as_get a_src astack
	node        = gs_get srcid graphstore
	descid      = n_descid node
	entry       = n_entry node
	arity       = n_arity node
	newargs     = n_args node arity ++ as_topn nr_args astack

create         :: State -> State
create st=:{astack,graphstore}
	= {st & astack=astack`, graphstore=graphstore`}
where
	astack`              = as_push nodeid astack
	(graphstore`,nodeid) = gs_newnode graphstore

del_args       :: ASrc NrArgs ADst State -> State
del_args a_src nr_args a_dst st=:{astack,graphstore}
	= {st & astack=astack`, graphstore=graphstore`}
where
	astack`     = as_pushn newargs astack
	graphstore` = gs_update dstid (n_fill descid entry newargs) graphstore
	dstid       = as_get a_dst astack
	srcid       = as_get a_src astack
	node        = gs_get srcid graphstore
	descid      = n_descid node
	entry       = n_entry node
	newargs     = n_nargs node (arity - nr_args) arity
	arity       = n_arity node

dump           :: String State -> State
dump s st=:{io}
	= {st & io=io_print ("\n" <+ s <+ "\n" <+ st) io}

eq_desc        :: DescId ASrc State -> State
eq_desc descid a_src st=:{astack,bstack,graphstore}
	= {st & bstack=bstack`}
where
	bstack` = bs_pushB equal bstack
	equal   = n_eq_descid node descid
	node    = gs_get nodeid graphstore
	nodeid  = as_get a_src astack

eq_desc_arity  :: DescId Arity ASrc State -> State
eq_desc_arity descid arity a_src st=:{astack,bstack,graphstore}
	= {st & bstack=bstack`}
where
	bstack` = bs_pushB equal bstack
	equal   = n_eq_descid node descid && n_eq_arity node arity
	node    = gs_get nodeid graphstore
	nodeid  = as_get a_src astack

eq_symbol      :: ASrc ASrc State -> State
eq_symbol a_src1 a_src2 st=:{astack,bstack,graphstore}
	= {st & bstack=bstack`}
where
	bstack`        = bs_pushB equal bstack
	equal          = n_eq_symbol node1 node2
	(node1, node2) = (gs_get id1 graphstore, gs_get id2 graphstore)
	(id1, id2)     = (as_get a_src1 astack, as_get a_src2 astack)

eqB            :: State -> State
eqB st=:{bstack}
	= {st & bstack=bs_eqB bstack}

eqB_a          :: Bool ASrc State -> State
eqB_a b a_src st=:{astack,bstack,graphstore}
	= {st & bstack=bstack`}
where
	bstack` = bs_pushB equal bstack
	equal   = n_eq_B (gs_get nodeid graphstore) b
	nodeid  = as_get a_src astack

eqB_b          :: Bool BSrc State -> State
eqB_b b b_src st=:{bstack}
	= {st & bstack=bs_eqBi b b_src bstack}

eqI            :: State -> State
eqI st=:{bstack}
	= {st & bstack=bs_eqI bstack}

eqI_a          :: Int ASrc State -> State
eqI_a i a_src st=:{astack,bstack,graphstore}
	= {st & bstack=bstack`}
where
	bstack` = bs_pushB equal bstack
	equal   = n_eq_I (gs_get nodeid graphstore) i
	nodeid  = as_get a_src astack

eqI_b          :: Int BSrc State -> State
eqI_b i b_src st=:{bstack}
	= {st & bstack=bs_eqIi i b_src bstack}

fill           :: DescId NrArgs InstrId ADst State -> State
fill desc nr_args entry a_dst st=:{astack,graphstore}
	= {st & astack=astack`, graphstore=graphstore`}
where
	astack`     = as_popn nr_args astack
	graphstore` = gs_update nodeid (n_fill desc entry args) graphstore
	nodeid      = as_get a_dst astack
	args        = as_topn nr_args astack

fill_a         :: ASrc ADst State -> State
fill_a a_src a_dst st=:{astack,graphstore}
	= {st & graphstore=graphstore`}
where
	graphstore` = gs_update nodeid_dst (n_copy node_src) graphstore
	node_src    = gs_get nodeid_src graphstore
	nodeid_dst  = as_get a_dst astack
	nodeid_src  = as_get a_src astack

fillB          :: Bool ADst State -> State
fillB b a_dst st=:{astack,graphstore}
	= {st & graphstore=graphstore`}
where
	graphstore` = gs_update nodeid (n_fillB bool_desc rnf_entry b) graphstore
	nodeid      = as_get a_dst astack

fillB_b        :: BSrc ADst State -> State
fillB_b b_src a_dst st=:{astack,bstack,graphstore}
	= {st & graphstore=graphstore`}
where
	graphstore` = gs_update nodeid (n_fillB bool_desc rnf_entry b) graphstore
	b           = bs_getB b_src bstack
	nodeid      = as_get a_dst astack

fillI          :: Int ADst State -> State
fillI i a_dst st=:{astack,graphstore}
	= {st & graphstore=graphstore`}
where
	graphstore` = gs_update nodeid (n_fillI int_desc rnf_entry i) graphstore
	nodeid      = as_get a_dst astack

fillI_b        :: BSrc ADst State -> State
fillI_b b_src a_dst st=:{astack,bstack,graphstore}
	= {st & graphstore=graphstore`}
where
	graphstore` = gs_update nodeid (n_fillI int_desc rnf_entry i) graphstore
	i           = bs_getI b_src bstack
	nodeid      = as_get a_dst astack

get_desc_arity :: ASrc State -> State
get_desc_arity a_src st=:{astack,bstack,descstore,graphstore}
	= {st & bstack=bstack`}
where
	bstack` = bs_pushI arity bstack
	arity   = d_arity (ds_get descid descstore)
	descid  = n_descid (gs_get nodeid graphstore)
	nodeid  = as_get a_src astack

get_node_arity :: ASrc State -> State
get_node_arity a_src st=:{astack,bstack,graphstore}
	= {st & bstack=bstack`}
where
	bstack` = bs_pushI arity bstack
	arity   = n_arity (gs_get nodeid graphstore)
	nodeid  = as_get a_src astack

halt           :: State -> State
halt st=:{pc}
	= {st & pc=pc_halt pc}

jmp            :: InstrId State -> State
jmp addr st
	= {st & pc=addr}

jmp_eval       :: State -> State
jmp_eval st=:{astack,graphstore}
	= {st & pc=pc`}
where
	pc`    = n_entry (gs_get nodeid graphstore)
	nodeid = as_get 0 astack

jmp_false      :: InstrId State -> State
jmp_false addr st=:{bstack,pc}
	= {st & bstack=bstack`, pc=pc`}
where
	pc`     = if (not b) addr pc
	b       = bs_getB 0 bstack
	bstack` = bs_popn 1 bstack

jmp_true       :: InstrId State -> State
jmp_true addr st=:{bstack,pc}
	= {st & bstack=bstack`, pc=pc`}
where
	pc`     = if b addr pc
	b       = bs_getB 0 bstack
	bstack` = bs_popn 1 bstack

jsr            :: InstrId State -> State
jsr addr st=:{cstack,pc}
	= {st & cstack=cstack`, pc=pc`}
where
	pc`     = addr
	cstack` = cs_push pc cstack

jsr_eval       :: State -> State
jsr_eval st=:{astack,cstack,graphstore,pc}
	= {st & cstack=cstack`, pc=pc`}
where
	pc`     = n_entry (gs_get nodeid graphstore)
	nodeid  = as_get 0 astack
	cstack` = cs_push pc cstack

no_op          :: State -> State
no_op st = st

pop_a          :: NrArgs State -> State
pop_a n st=:{astack}
	= {st & astack=as_popn n astack}

pop_b          :: NrArgs State -> State
pop_b n st=:{bstack}
	= {st & bstack=bs_popn n bstack}

print          :: String State -> State
print s st=:{io}
	= {st & io=io_print s io}

print_symbol   :: ASrc State -> State
print_symbol a_src st=:{astack,descstore,graphstore,io}
	= {st & io=io`}
where
	io`    = io_print string io
	string = show_node node desc
	desc   = ds_get (n_descid node) descstore
	node   = gs_get nodeid graphstore
	nodeid = as_get a_src astack

push_a         :: ASrc State -> State
push_a a_src st=:{astack}
	= {st & astack=as_push (as_get a_src astack) astack}

push_ap_entry  :: ASrc State -> State
push_ap_entry a_src st=:{astack,cstack,descstore,graphstore}
	= {st & cstack=cstack`}
where
	cstack` = cs_push (d_ap_entry (ds_get descid descstore)) cstack
	descid  = n_descid (gs_get nodeid graphstore)
	nodeid  = as_get a_src astack

push_arg       :: ASrc Arity ArgNr State -> State
push_arg a_src arity arg_nr st=:{astack,graphstore}
	= {st & astack=astack`}
where
	astack` = as_push arg astack
	arg     = n_arg (gs_get nodeid graphstore) arg_nr arity
	nodeid  = as_get a_src astack

push_arg_b     :: ASrc State -> State
push_arg_b a_src st=:{astack,bstack,graphstore}
	= {st & astack=astack`}
where
	astack` = as_push arg astack
	arg     = n_arg (gs_get nodeid graphstore) arg_nr arity
	nodeid  = as_get a_src astack
	arg_nr  = bs_getI 0 bstack
	arity   = bs_getI 1 bstack

push_args      :: ASrc Arity NrArgs State -> State
push_args a_src arity nr_args st=:{astack,graphstore}
	= {st & astack=astack`}
where
	astack` = as_pushn args astack
	args    = n_nargs (gs_get nodeid graphstore) nr_args arity
	nodeid  = as_get a_src astack

push_args_b    :: ASrc State -> State
push_args_b a_src st=:{astack,bstack,graphstore}
	= {st & astack=astack`}
where
	astack` = as_pushn args astack
	args    = n_nargs (gs_get nodeid graphstore) nargs arity
	nargs   = bs_getI 0 bstack
	nodeid  = as_get a_src astack
	arity   = bs_getI 1 bstack

push_b         :: BSrc State -> State
push_b b_src st=:{bstack}
	= {st & bstack=bs_push (bs_get b_src bstack) bstack}

pushB          :: Bool State -> State
pushB b st=:{bstack}
	= {st & bstack=bs_pushB b bstack}

pushB_a        :: ASrc State -> State
pushB_a a_src st=:{astack,bstack,graphstore}
	= {st & bstack=bstack`}
where
	bstack` = bs_pushB b bstack
	b       = n_B (gs_get nodeid graphstore)
	nodeid  = as_get a_src astack

pushI          :: Int State -> State
pushI i st=:{bstack}
	= {st & bstack=bs_pushI i bstack}

pushI_a        :: ASrc State -> State
pushI_a a_src st=:{astack,bstack,graphstore}
	= {st & bstack=bstack`}
where
	bstack` = bs_pushI i bstack
	i       = n_I (gs_get nodeid graphstore)
	nodeid  = as_get a_src astack

repl_args      :: Arity NrArgs State -> State
repl_args arity nr_args st=:{astack,graphstore}
	= {st & astack=astack`}
where
	astack` = as_pushn args (as_popn 1 astack)
	args    = n_nargs (gs_get nodeid graphstore) nr_args arity
	nodeid  = as_get 0 astack

repl_args_b    :: State -> State
repl_args_b st=:{astack,bstack,graphstore}
	= {st & astack=astack`}
where
	astack` = as_pushn args (as_popn 1 astack)
	args    = n_nargs (gs_get nodeid graphstore) nr_args arity
	nodeid  = as_get 0 astack
	arity   = bs_getI 0 bstack
	nr_args = bs_getI 1 bstack

rtn            :: State -> State
rtn st=:{cstack}
	= {st & cstack=cs_popn 1 cstack, pc=cs_get 0 cstack}

set_entry      :: InstrId ADst State -> State
set_entry entry a_dst st=:{astack,graphstore}
	= {st & graphstore=graphstore`}
where
	graphstore` = gs_update nodeid (n_setentry entry) graphstore
	nodeid      = as_get a_dst astack

update_a       :: ASrc ADst State -> State
update_a a_src a_dst st=:{astack}
	= {st & astack=as_update a_dst (as_get a_src astack) astack}

update_b       :: BSrc BDst State -> State
update_b b_src b_dst st=:{bstack}
	= {st & bstack=bs_update b_dst (bs_get b_src bstack) bstack}


addI :: State -> State
addI st=:{bstack}
	= {st & bstack=bs_addI bstack}

decI :: State -> State
decI st=:{bstack}
	= {st & bstack=bs_decI bstack}

gtI  :: State -> State
gtI st=:{bstack}
	= {st & bstack=bs_gtI bstack}

incI :: State -> State
incI st=:{bstack}
	= {st & bstack=bs_incI bstack}

ltI  :: State -> State
ltI st=:{bstack}
	= {st & bstack=bs_ltI bstack}

mulI :: State -> State
mulI st=:{bstack}
	= {st & bstack=bs_mulI bstack}

subI :: State -> State
subI st=:{bstack}
	= {st & bstack=bs_subI bstack}
