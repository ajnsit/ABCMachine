definition module ABC.GraphStore

from ABC.Def import ::NodeId
from ABC.Nodes import ::Node

:: GraphStore

gs_get     :: NodeId GraphStore -> Node
gs_init    :: GraphStore
gs_newnode :: GraphStore -> (GraphStore, NodeId)
gs_update  :: NodeId (Node -> Node) GraphStore -> GraphStore
