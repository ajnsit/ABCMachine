implementation module ABC.Machine.Program

import StdEnv

import ABC.Machine
import ABC.Misc

pc_init :: InstrId
pc_init = 0

pc_next :: InstrId -> InstrId
pc_next i = i + 1

pc_halt :: InstrId -> InstrId
pc_halt _ = -1

pc_end  :: InstrId -> Bool
pc_end i = i < 0

:: Location     =   I Instruction
:: ProgramStore :== {Location}

ps_get  :: InstrId ProgramStore -> Instruction
ps_get n p = let (I i) = p.[n] in i

ps_init :: [Instruction] -> ProgramStore
ps_init is = {I i \\ i <- is}
