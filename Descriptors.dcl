definition module ABC.Descriptors

from ABC.Def import ::Arity, ::InstrId

:: Desc = Desc APEntry Arity Name

d_ap_entry :: Desc -> InstrId
d_arity    :: Desc -> Arity
d_name     :: Desc -> String

:: DescStore (:== [Desc])

ds_get     :: DescId DescStore -> Desc
ds_init    :: [Desc] -> DescStore
