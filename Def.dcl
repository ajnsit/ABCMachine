definition module ABC.Def

from ABC.AStack import ::AStack
from ABC.BStack import ::BStack
from ABC.CStack import ::CStack
from ABC.GraphStore import ::GraphStore
from ABC.Descriptors import ::DescStore
from ABC.Program import ::ProgramStore
from ABC.IO import ::IO

:: State = { astack     :: AStack
           , bstack     :: BStack
           , cstack     :: CStack
           , graphstore :: GraphStore
           , descstore  :: DescStore
           , pc         :: InstrId
           , program    :: ProgramStore
           , io         :: IO
           }

:: NodeId  :== Int
:: NrArgs  :== Int
:: ArgNr   :== Int
:: DescId  :== Int
:: InstrId :== Int
:: Name    :== String

:: Instruction :== State -> State

:: APEntry :== InstrId
:: Args    :== [NodeId]
