definition module ABC.Machine.IO

from StdOverloaded import class toString

from ABC.Machine.Nodes import ::Node
from ABC.Machine.GraphStore import ::Desc
from ABC.Machine.Def import ::State

:: IO (:== [Char])

instance toString IO

io_init  :: IO
io_print :: a IO -> IO | toString a

show_node :: Node Desc -> String
instance toString State
