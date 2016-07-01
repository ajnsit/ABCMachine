implementation module ABC.Driver

import StdEnv, StdDebug

import ABC.Machine

boot        :: ([Instruction], [Desc]) -> State
boot (prog,descs)
	= { astack     = as_init
	  , bstack     = bs_init
	  , cstack     = cs_init
	  , graphstore = gs_init
	  , descstore  = ds_init descs
	  , pc         = pc_init
	  , program    = ps_init prog
	  , io         = io_init
	  }

fetch_cycle :: State -> State
fetch_cycle st=:{pc,program}
//# pc = trace_n pc pc
| pc_end pc = st
| otherwise = fetch_cycle (currinstr {st & pc=pc`})
where
	pc`       = pc_next pc
	currinstr = ps_get pc program
