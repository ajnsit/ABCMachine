implementation module ABC.Machine.CStack

import StdEnv

import ABC.Machine
import ABC.Misc

:: CStack :== [InstrId]

instance toString CStack where toString xs = "[" <++ (",", xs) <+ "]"

cs_init :: CStack
cs_init = []

cs_get  :: CSrc CStack -> InstrId
cs_get _ []    = abortn "cs_get: index too large"
cs_get 0 [i:_] = i
cs_get i [_:s] = cs_get (i-1) s

cs_popn :: CSrc CStack -> CStack
cs_popn 0 s     = s
cs_popn _ []    = abortn "cs_popn: popping too many elements"
cs_popn i [_:s] = cs_popn (i-1) s

cs_push :: InstrId CStack -> CStack
cs_push i s = [i:s]
