implementation module ABC.Program

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
:: ProgramStore :== [Location]

ps_get  :: InstrId ProgramStore -> Instruction
ps_get 0 [I p:_] = p
ps_get _ []      = abortn "ps_get: index too large"
ps_get i [_:ps]  = ps_get (i-1) ps

ps_init :: [Instruction] -> ProgramStore
ps_init []     = []
ps_init [i:is] = [I i:ps_init is]
