implementation module ABC.Assembler

import StdEnv
import StdGeneric

import ABC.Machine
import ABC.Misc

instance toString Assembler
where
	toString []                            = ""
	toString [stm=:(Label l):r]            = stm <+ "\r\n" <+ r
	toString [stm=:(Descriptor _ _ _ _):r] = toString r
	toString [stm                      :r] = "\t" <+ stm <+ "\r\n" <+ r

instance <<< Assembler
where
	<<< f []                            = f
	<<< f [stm=:(Label l):r]            = f <<< stm <<< "\r\n" <<< r
	<<< f [stm=:(Descriptor _ _ _ _):r] = f <<< r
	<<< f [stm                      :r] = f <<< "\t" <<< stm <<< "\r\n" <<< r

instance <<< Statement where <<< f st = f <<< toString st

generic gPrint a :: !a -> [Char]
gPrint{|Int|}          x          = fromString (toString x)
gPrint{|Bool|}         x          = map toLower (fromString (toString x))
gPrint{|String|}       x          = fromString x
gPrint{|UNIT|}         x          = []
gPrint{|EITHER|} fl fr (LEFT x)   = fl x
gPrint{|EITHER|} fl fr (RIGHT x)  = fr x
gPrint{|PAIR|}   fl fr (PAIR x y) = fl x ++ ['\t':fr y]
gPrint{|OBJECT|} fx    (OBJECT x) = fx x
gPrint{|CONS of d|} fx (CONS x)   = case d.gcd_name of
	"Label"      = fx x
	"Descriptor" = []
	"Dump"       = ['dump\t"']  ++ quote (fx x) ++ ['"']
	"Print"      = ['print\t"'] ++ quote (fx x) ++ ['"']
	"Comment"    = ['| '] ++ fx x
	name         = tl (cons (fromString name)) ++ ['\t':fx x]
where
	cons :: ![Char] -> [Char]
	cons [] = []
	cons [c:cs]
	| isUpper c
		| isMember c ['IB'] && isEmpty cs   = [c]
		| isMember c ['IB'] && hd cs == '_' = [c            :cons cs]
		| otherwise                         = ['_':toLower c:cons cs]
	| otherwise                             = [c            :cons cs]

derive gPrint Statement

instance toString Statement
where
	toString stm = toString (gPrint{|*|} stm)

quote :: ![Char] -> [Char]
quote []        = []
quote ['\\':cs] = ['\\':'\\':quote cs]
quote ['\n':cs] = ['\\':'n' :quote cs]
quote ['"' :cs] = ['\\':'"' :quote cs]
quote [c   :cs] = [c        :quote cs]

assemble :: Assembler -> ([Instruction], [Desc])
assemble stms = (translate stms loc_counter syms, descTable stms syms)
where
	loc_counter  = 0
	desc_counter = 0
	syms         = collect stms loc_counter desc_counter

:: SymType  =   LabSym | DescSym

instance == SymType
where
	(==) LabSym  LabSym  = True
	(==) DescSym DescSym = True
	(==) _       _       = False

instance toString SymType
where
	toString LabSym  = "label"
	toString DescSym = "descriptor"

:: SymTable :== [(Name, Int, SymType)]

collect :: Assembler Int Int -> SymTable
collect []                       _  _  = []
collect [Label l            :r] lc dc = [(l,lc,LabSym)  :collect r lc dc]
collect [Descriptor dl _ _ _:r] lc dc = [(dl,dc,DescSym):collect r lc (dc+1)]
collect [_                  :r] lc dc = collect r (lc+1) dc

lookup :: Label SymType SymTable -> Int
lookup l t [] = abortn (l <+ " not defined as " <+ t)
lookup l t [(name,n,type):r]
| l == name && t == type = n
| otherwise              = lookup l t r

descTable :: Assembler SymTable -> [Desc]
descTable []                      _    = []
descTable [Descriptor dl e a n:r] syms = [Desc ap_addr a n:descTable r syms]
where ap_addr = lookup e LabSym syms
descTable [_                  :r] syms = descTable r syms

translate :: Assembler Int SymTable -> [Instruction]
translate []                     _  _    = []
translate [Label _           :r] lc syms = translate r lc syms
translate [Descriptor _ _ _ _:r] lc syms = translate r lc syms
translate [Comment _         :r] lc syms = translate r lc syms
translate [stm               :r] lc syms
	= [trans stm lc syms:translate r (lc+1) syms]
where
	trans :: Statement Int SymTable -> Instruction
	trans (Br n)               lc _    = jmp            (lc+n+1)
	trans (BrFalse n)          lc _    = jmp_false      (lc+n+1)
	trans (BrTrue n)           lc _    = jmp_true       (lc+n+1)
	trans (Dump s)             _  _    = dump           s
	trans (AddArgs s n d)      _  _    = add_args       s n d
	trans Create               _  _    = create
	trans (DelArgs s n d)      _  _    = del_args       s n d
	trans (EqDesc dl s)        _  syms = eq_desc        daddr s
		where daddr = (lookup dl DescSym syms)
	trans (EqDescArity dl a s) _  syms = eq_desc_arity  daddr a s
		where daddr = (lookup dl DescSym syms)
	trans EqB                  _  _    = eqB
	trans (EqB_a b s)          _  _    = eqB_a b s
	trans (EqB_b b s)          _  _    = eqB_b b s
	trans EqI                  _  _    = eqI
	trans (EqI_a i s)          _  _    = eqI_a i s
	trans (EqI_b i s)          _  _    = eqI_b i s
	trans (Fill l n e d)       _  syms = fill daddr     n eaddr d
		where (daddr,eaddr) = (lookup l DescSym syms, lookup e LabSym syms)
	trans (Fill_a s d)         _  _    = fill_a s d
	trans (FillB b d)          _  _    = fillB b d
	trans (FillB_b s d)        _  _    = fillB_b s d
	trans (FillI i d)          _  _    = fillI i d
	trans (FillI_b s d)        _  _    = fillI_b s d
	trans (GetDescArity s)     _  _    = get_desc_arity s
	trans (GetNodeArity s)     _  _    = get_node_arity s
	trans Halt                 _  _    = halt
	trans (Jmp l)              _  syms = jmp            addr
		where addr = lookup l LabSym syms
	trans JmpEval              _  _    = jmp_eval
	trans (JmpFalse l)         _  syms = jmp_false      addr
		where addr = lookup l LabSym syms
	trans (JmpTrue l)          _  syms = jmp_true       addr
		where addr = lookup l LabSym syms
	trans (Jsr l)              _  syms = jsr            addr
		where addr = lookup l LabSym syms
	trans JsrEval              _  _    = jsr_eval
	trans NoOp                 _  _    = no_op
	trans (Pop_a n)            _  _    = pop_a          n
	trans (Pop_b n)            _  _    = pop_b          n
	trans (Print s)            _  _    = print          s
	trans (PrintSymbol s)      _  _    = print_symbol   s
	trans (Push_a s)           _  _    = push_a         s
	trans (PushAPEntry s)      _  _    = push_ap_entry  s
	trans (PushArg s a n)      _  _    = push_arg       s a n
	trans (PushArg_b s)        _  _    = push_arg_b     s
	trans (PushArgs s a n)     _  _    = push_args      s a n
	trans (PushArgs_b s)       _  _    = push_args_b    s
	trans (Push_b i)           _  _    = push_b         i
	trans (PushB b)            _  _    = pushB          b
	trans (PushB_a s)          _  _    = pushB_a        s
	trans (PushI i)            _  _    = pushI          i
	trans (PushI_a s)          _  _    = pushI_a        s
	trans (ReplArgs a n)       _  _    = repl_args      a n
	trans ReplArgs_b           _  _    = repl_args_b
	trans Rtn                  _  _    = rtn
	trans (SetEntry l d)       _  syms = set_entry      addr d
		where addr = lookup l LabSym syms
	trans (Update_a s d)       _  _    = update_a       s d
	trans (Update_b s d)       _  _    = update_b       s d
	trans AddI                 _  _    = addI
	trans DecI                 _  _    = decI
	trans GtI                  _  _    = gtI
	trans IncI                 _  _    = incI
	trans LtI                  _  _    = ltI
	trans MulI                 _  _    = mulI
	trans SubI                 _  _    = subI
