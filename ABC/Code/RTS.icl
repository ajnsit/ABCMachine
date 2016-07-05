implementation module ABC.Code.RTS

import ABC.Assembler

rts :: Assembler
rts
	= [       Descriptor      "INT"  "_rnf" 0 "integer"
	  ,       Descriptor      "BOOL" "_rnf" 0 "boolean"
	  ,       Jmp             "init_graph"
	  , Label "_rnf"
	  ,       Rtn
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
	  ,       Pop_b           1
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
	  , Label "_cycle"
	  ,       Print           "cycle in spine\n"
	  ,       Halt
	  , Label "_type_error"   
	  ,       Print           "type error\n"
	  ,       Halt
	  ]
