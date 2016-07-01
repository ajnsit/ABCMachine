definition module ABC.IO

from StdOverloaded import class toString

from ABC.Nodes import ::Node
from ABC.GraphStore import ::Desc
from ABC.Def import ::State

:: IO (:== [Char])

io_init  :: IO
io_print :: a IO -> IO | toString a

show_node :: Node Desc -> String
instance toString State
