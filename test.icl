module test

import StdEnv

import ABC.Machine

Start = toString end.io
where
	(prog,descs) = assemble length
	state        = boot (prog,descs)
	end          = fetch_cycle state

rts :: Assembler
rts
	= [ Descriptor "INT" "_rnf" 0 "integer"
	  , Descriptor "BOOL" "_rnf" 0 "boolean"
	  ,       Jmp             "init_graph"
	  , Label "init_graph"
	  ,       Create
	  ,       Fill            "Start" 0 "n_Start" 0
	  ,       Jsr             "_driver"
	  ,       Print           "\n"
	  ,       Halt
	  , Label "_driver"
	  ,       PushI           0
	  , Label "_print"
	  ,       JsrEval
	  ,       GetNodeArity    0
	  ,       EqI_b           0 0
	  ,       JmpFalse        "_args"
	  , Label "_print_last"   
	  ,       PrintSymbol     0
	  ,       Pop_a           1
	  ,       Pop_b           1
	  , Label "_brackets"
	  ,       EqI_b           0 0
	  ,       JmpTrue         "_exit"
	  ,       Print           ")"
	  ,       DecI
	  ,       Jmp             "_brackets"
	  , Label "_exit"
	  ,       Rtn
	  , Label "_args"
	  ,       Print           "("
	  ,       PrintSymbol     0
	  ,       GetDescArity    0
	  ,       ReplArgs_b
	  ,       Pop_b           1
	  , Label "_arg_loop"
	  ,       Print           " "
	  ,       EqI_b           1 0
	  ,       JmpFalse        "_next_arg"
	  ,       Pop_b           1
	  ,       IncI
	  ,       Jmp             "_print"
	  , Label "_next_arg"
	  ,       Jsr             "_driver"
	  ,       DecI
	  ,       Jmp             "_arg_loop"
	  , Label "_rnf"
	  ,       Rtn
	  , Label "_cycle"
	  ,       Print           "cycle in spine\n"
	  ,       Halt
	  , Label "_type_error"   
	  ,       Print           "type error\n"
	  ,       Halt
	  ]

ints :: Assembler
ints
	= [ Label "+I1"
	  ,       IncI
	  ,       Rtn
	  ]

list :: Assembler
list
	= [ Descriptor    "Cons" "_rnf" 2 "Cons"
	  , Descriptor    "Nil" "_rnf" 0 "Nil"
	  ]

length :: Assembler // p. 87-88
length
	= rts ++
	  list ++
	  ints ++
	  [ Descriptor    "Length" "a_Length" 2 "Length"

	  , Label         "n_Length"
	  , SetEntry      "_cycle" 0
	  , PushArgs      0 2 2
	  
	  , Label         "a_Length"
	  , Push_a        1
	  , JsrEval
	  , Pop_a         1

	  , Label         "Length1"
	  , EqDescArity   "Cons" 2 1
	  , JmpFalse      "Length2"
	  , PushArgs      1 2 2
	  , Push_a        1
	  , JsrEval
	  , Create
	  , Create
	  , FillI         1 0
	  , Push_a        5
	  , Jsr           "+I1"
	  , Update_a      1 5
	  , Update_a      0 4
	  , Pop_a         4
	  , Jmp           "Length1"

	  , Label         "Length2"
	  , EqDescArity   "Nil" 0 1
	  , JmpFalse      "Length3"
	  , Fill_a        0 2
	  , Pop_a         2
	  , Rtn

	  , Label         "Length3"
	  , Jmp           "_type_error"

	  , Descriptor    "Start" "n_Start" 0 "Start"
	  , Label         "n_Start"
	  , Create
	  , Create
	  , Create
	  , Fill          "Nil" 0 "_rnf" 0
	  , Create
	  , FillI         1 0
	  , Fill          "Cons" 2 "_rnf" 2
	  , Fill          "Length" 1 "n_Length" 1
	  //, Jmp           "_driver"
	  , Dump          ""
	  , Halt
	  ]

cons_1_nil :: Assembler // p. 45, doesn't work (Nil/Cons no descriptors)
cons_1_nil
	= [ Create
	  , Create
	  , Fill    "Nil" 0 "_rnf" 0
	  , Create
	  , FillI   1 0
	  , Fill    "Cons" 2 "_rnf" 2
	  ]
