definition module ABC.Driver

from ABC.Def import ::State, ::Instruction
from ABC.GraphStore import ::Desc

boot        :: ([Instruction], [Desc]) -> State
fetch_cycle :: State -> State
