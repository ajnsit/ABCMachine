definition module ABC.CStack

from ABC.Def import ::InstrId

:: CSrc    :== Int
:: CDst    :== Int
:: CStack (:== [InstrId])

cs_init :: CStack
cs_get  :: CSrc CStack -> InstrId
cs_popn :: CSrc CStack -> CStack
cs_push :: InstrId CStack -> CStack
