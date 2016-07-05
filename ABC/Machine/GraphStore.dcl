definition module ABC.Machine.GraphStore

from StdOverloaded import class toString
from ABC.Machine.Def import ::Arity, ::InstrId, ::Name, ::APEntry, ::DescId, ::NodeId
from ABC.Machine.Nodes import ::Node

:: Desc = Desc APEntry Arity Name

d_ap_entry :: Desc -> InstrId
d_arity    :: Desc -> Arity
d_name     :: Desc -> String

:: DescStore (:== [Desc])

ds_get     :: DescId DescStore -> Desc
ds_init    :: [Desc] -> DescStore

:: GraphStore

show_graphstore :: GraphStore DescStore -> String

gs_get     :: NodeId GraphStore -> Node
gs_init    :: GraphStore
gs_newnode :: GraphStore -> (GraphStore, NodeId)
gs_update  :: NodeId (Node -> Node) GraphStore -> GraphStore
