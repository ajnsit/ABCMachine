definition module ABC.Program

from ABC.Def import ::InstrId, ::Instruction

pc_init :: InstrId
pc_next :: InstrId -> InstrId
pc_halt :: InstrId -> InstrId
pc_end  :: InstrId -> Bool

:: ProgramStore

ps_get  :: InstrId ProgramStore -> Instruction
ps_init :: [Instruction] -> ProgramStore
