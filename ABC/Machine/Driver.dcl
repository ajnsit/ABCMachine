definition module ABC.Machine.Driver

from ABC.Machine.Def import ::State, ::Instruction
from ABC.Machine.GraphStore import ::Desc

boot        :: ([Instruction], [Desc]) -> State
fetch_cycle :: State -> State
