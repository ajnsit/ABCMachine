definition module ABC.Assembler

from ABC.Def import ::Arity, ::Name, ::NrArgs, ::ArgNr, ::Instruction, ::State
from ABC.AStack import ::ASrc, ::ADst
from ABC.BStack import ::BSrc, ::BDst
from ABC.GraphStore import ::Desc

:: Label     :== String
:: RedLabel  :== Label
:: DescLabel :== Label
:: NrInstr   :== Int

:: Assembler :== [Statement]

:: Statement
	= Label        Label
	| Descriptor   DescLabel RedLabel Arity Name
	| Br           NrInstr
	| BrFalse      NrInstr
	| BrTrue       NrInstr
	| Dump         String
	| AddArgs      ASrc NrArgs ADst
	| Create
	| DelArgs      ASrc NrArgs ADst
	| EqDesc       DescLabel ASrc
	| EqDescArity  DescLabel Arity ASrc
	| EqB
	| EqB_a        Bool ASrc
	| EqB_b        Bool BSrc
	| EqI
	| EqI_a        Int ASrc
	| EqI_b        Int BSrc
	| Fill         DescLabel NrArgs Label ADst
	| Fill_a       ASrc ADst
	| FillB        Bool ADst
	| FillB_b      BSrc ADst
	| FillI        Int ADst
	| FillI_b      BSrc ADst
	| GetDescArity ASrc
	| GetNodeArity ASrc
	| Halt
	| Jmp          Label
	| JmpEval
	| JmpFalse     Label
	| JmpTrue      Label
	| Jsr          Label
	| JsrEval
	| NoOp
	| Pop_a        Int
	| Pop_b        Int
	| Print        String
	| PrintSymbol  ASrc
	| Push_a       ASrc
	| PushAPEntry  ASrc
	| PushArg      ASrc Arity ArgNr
	| PushArg_b    ASrc
	| PushArgs     ASrc Arity ArgNr
	| PushArgs_b   ASrc
	| Push_b       Int
	| PushB        Bool
	| PushB_a      ASrc
	| PushI        Int
	| PushI_a      ASrc
	| ReplArgs     Arity NrArgs
	| ReplArgs_b
	| Rtn
	| SetEntry     Label ADst
	| Update_a     ASrc ADst
	| Update_b     BSrc BDst
	| AddI
	| DecI
	| GtI 
	| IncI
	| LtI
	| MulI
	| SubI

assemble :: Assembler -> ([Instruction], [Desc])
