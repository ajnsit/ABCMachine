implementation module ABC.Descriptors

import StdEnv

import ABC.Machine
import ABC.Misc

d_ap_entry :: Desc -> InstrId
d_ap_entry (Desc e _ _) = e

d_arity    :: Desc -> Arity
d_arity (Desc _ a _) = a

d_name     :: Desc -> String
d_name (Desc _ _ n) = n


ds_get     :: DescId DescStore -> Desc
ds_get 0 [d:_] = d
ds_get _ []    = abortn "ds_get: index too large"
ds_get i [_:s] = ds_get (i-1) s

ds_init    :: [Desc] -> DescStore
ds_init ds = ds
