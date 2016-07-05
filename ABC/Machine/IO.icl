implementation module ABC.Machine.IO

import StdEnv

import ABC.Machine
import ABC.Misc

:: IO :== [Char]

instance toString IO where toString io = {c \\ c <- io}

io_init  :: IO
io_init = []

io_print :: a IO -> IO | toString a
io_print x io = io ++ fromString (toString x)

show_node :: Node Desc -> String
show_node (Basic _ _ b) _           = toString b
show_node (Node _ _ _) (Desc _ _ n) = n

instance toString State
where
	toString {astack,bstack,cstack,graphstore,descstore,pc,program,io}
		= "pc      : " <+ pc <+ "\n" <+
		  "A-stack : " <+ astack <+ "\n" <+
		  "B-stack : " <+ bstack <+ "\n" <+
		  "C-stack : " <+ cstack <+ "\n" <+
		  "Graph   :\n" <+ show_graphstore graphstore descstore
