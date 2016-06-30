definition module ABC.BStack

:: Basic   = Int  Int
           | Bool Bool

:: BSrc    :== Int
:: BDst    :== Int
:: BStack (:== [Basic])

bs_copy   :: BSrc BStack -> BStack
bs_get    :: BSrc BStack -> Basic
bs_getB   :: BSrc BStack -> Bool
bs_getI   :: BSrc BStack -> Int
bs_init   :: BStack
bs_popn   :: NrArgs BStack -> BStack
bs_push   :: Dynamic BStack -> BStack
bs_pushB  :: Bool BStack -> BStack
bs_pushI  :: Int BStack -> BStack
bs_update :: BDst Dynamic BStack -> BStack
bs_addI   :: BStack -> BStack
bs_decI   :: BStack -> BStack
bs_incI   :: BStack -> BStack
bs_eqB    :: BStack -> BStack
bs_eqI    :: BStack -> BStack
bs_eqBi   :: Bool BSrc BStack -> BStack
bs_eqIi   :: Int BSrc BStack -> BStack
bs_gtI    :: BStack -> BStack
bs_ltI    :: BStack -> BStack
bs_mulI   :: BStack -> BStack
bs_subI   :: BStack -> BStack
