implementation module ABC.Machine.BStack

import StdEnv

import ABC.Machine
import ABC.Misc

instance == Basic
where
	(==) (Bool b) (Bool c) = b == c
	(==) (Int m)  (Int n)  = m == n
	(==) _        _        = False

instance toString Basic
where
	toString (Bool b) = toString b
	toString (Int i)  = toString i

:: BStack :== [Basic]

instance toString BStack where toString xs = "[" <++ (",", xs) <+ "]"

bs_copy   :: BSrc BStack -> BStack
bs_copy i s = [bs_get i s:s]

bs_get    :: BSrc BStack -> Basic
bs_get _ []    = abortn "bs_get: index too large"
bs_get 0 [b:s] = b
bs_get i [_:s] = bs_get (i-1) s

bs_getB   :: BSrc BStack -> Bool
bs_getB i s = case bs_get i s of
	(Bool b) = b
	_        = abortn "bs_getB on non-Bool value\n"

bs_getI   :: BSrc BStack -> Int
bs_getI i s = case bs_get i s of
	(Int i) = i
	_       = abortn "bs_getI on non-Int value\n"

bs_init   :: BStack
bs_init = []

bs_popn   :: NrArgs BStack -> BStack
bs_popn 0 s     = s
bs_popn _ []    = abortn "bs_popn: popping too many elements"
bs_popn i [_:s] = bs_popn (i - 1) s

bs_push   :: Basic BStack -> BStack
bs_push d s = [d:s]

bs_pushB  :: Bool BStack -> BStack
bs_pushB b s = [Bool b:s]

bs_pushI  :: Int BStack -> BStack
bs_pushI i s = [Int i:s]

bs_update :: BDst Basic BStack -> BStack
bs_update 0 d [_:s] = [d:s]
bs_update _ _ []    = abortn "bs_update: index too large"
bs_update i d [e:s] = [e:bs_update (i - 1) d s]

bs_addI   :: BStack -> BStack
bs_addI [Int m:Int n:s] = bs_pushI (m + n) s
bs_addI _               = abortn "bs_addI: no integers"

bs_decI   :: BStack -> BStack
bs_decI [Int n:s] = bs_pushI (n-1) s
bs_decI _         = abortn "bs_decI: no integer"

bs_divI   :: BStack -> BStack
bs_divI [Int m:Int n:s] = bs_pushI (m / n) s
bs_divI _               = abortn "bs_divI: no integers"

bs_incI   :: BStack -> BStack
bs_incI [Int n:s] = bs_pushI (n + 1) s
bs_incI _         = abortn "bs_incI: no integer"

bs_eqB    :: BStack -> BStack
bs_eqB [Bool b:Bool c:s] = bs_pushB (b == c) s
bs_eqB _                 = abortn "bs_eqB: no booleans"

bs_eqI    :: BStack -> BStack
bs_eqI [Int m:Int n:s] = bs_pushB (m == n) s
bs_eqI _               = abortn "bs_eqI: no integers"

bs_eqBi   :: Bool BSrc BStack -> BStack
bs_eqBi b i s = bs_pushB (bs_getB i s == b) s

bs_eqIi   :: Int BSrc BStack -> BStack
bs_eqIi n i s = bs_pushB (bs_getI i s == n) s

bs_gtI    :: BStack -> BStack
bs_gtI [Int m:Int n:s] = bs_pushB (m > n) s
bs_gtI _               = abortn "bs_gtI: no integers"

bs_ltI    :: BStack -> BStack
bs_ltI [Int m:Int n:s] = bs_pushB (m < n) s
bs_ltI _               = abortn "bs_ltI: no integers"

bs_mulI   :: BStack -> BStack
bs_mulI [Int m:Int n:s] = bs_pushI (m * n) s
bs_mulI _               = abortn "bs_mulI: no integers"

bs_negI   :: BStack -> BStack
bs_negI [Int n:s] = bs_pushI (~n) s
bs_negI _         = abortn "bs_negI: no integer"

bs_remI   :: BStack -> BStack
bs_remI [Int m:Int n:s] = bs_pushI (m rem n) s
bs_remI _               = abortn "bs_remI: no integers"

bs_subI   :: BStack -> BStack
bs_subI [Int m:Int n:s] = bs_pushI (m - n) s
bs_subI _               = abortn "bs_subI: no integers"
