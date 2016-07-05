definition module ABC.Machine.Def

from ABC.Machine.AStack import ::AStack
from ABC.Machine.BStack import ::BStack
from ABC.Machine.CStack import ::CStack
from ABC.Machine.GraphStore import ::GraphStore, ::DescStore
from ABC.Machine.Program import ::ProgramStore
from ABC.Machine.IO import ::IO

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
:: Arity   :== Int

:: Instruction :== State -> State

:: APEntry :== InstrId
:: Args    :== [NodeId]
