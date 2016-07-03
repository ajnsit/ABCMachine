module test

import StdEnv

import ABC.Machine
import ABC.Code

Start = toString end.io
where
	(prog,descs) = assemble length
	state        = boot (prog,descs)
	end          = fetch_cycle state

ints :: Assembler
ints
	= [ Label "+I1"
	  ,       PushI_a       0
	  ,       PushI_a       1
	  ,       AddI
	  ,       Pop_a         1
	  ,       FillI_b       0 0
	  ,       Pop_b         1
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
	  [       Descriptor    "Length" "a_Length" 2 "Length"

	  , Label "n_Length"
	  ,       SetEntry      "_cycle" 0
	  ,       PushArgs      0 2 2
	  
	  , Label "a_Length"
	  ,       Push_a        1
	  ,       JsrEval
	  ,       Pop_a         1

	  , Label "Length1"
	  ,       EqDescArity   "Cons" 2 1
	  ,       JmpFalse      "Length2"
	  ,       PushArgs      1 2 2
	  ,       Push_a        1
	  ,       JsrEval
	  ,       Create
	  ,       FillI         1 0
	  ,       Push_a        4
	  ,       Jsr           "+I1"
	  ,       Update_a      1 5
	  ,       Update_a      0 4
	  ,       Pop_a         4
	  ,       Jmp           "Length1"

	  , Label "Length2"
	  ,       EqDescArity   "Nil" 0 1
	  ,       JmpFalse      "Length3"
	  ,       Fill_a        0 2
	  ,       Pop_a         2
	  ,       Rtn

	  , Label "Length3"
	  ,       Jmp           "_type_error"

	  ,       Descriptor    "Start" "n_Start" 0 "Start"
	  , Label "n_Start"
	  ,       Create
	  ,       Create
	  ,       Create
	  ,       Create
	  ,       Fill          "Nil" 0 "_rnf" 1
	  ,       FillI         5 0
	  ,       Fill          "Cons" 2 "_rnf" 2
	  ,       Create
	  ,       FillI         3 0
	  ,       Fill          "Cons" 2 "_rnf" 2
	  ,       Create
	  ] ++    show_list ++
	  [       JsrEval
	  ,       Rtn
	  ]
where
	show_length
		= [ FillI           0 0
		  , Fill            "Length" 2 "n_Length" 2
		  ]

	show_list
		= [ FillI           2 0
		  , Fill            "Cons" 2 "_rnf" 2
		  ]
