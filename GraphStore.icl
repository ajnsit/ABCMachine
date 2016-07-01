implementation module ABC.GraphStore

import StdEnv

import ABC.Machine
import ABC.Misc

STORE_SIZE :== 1000

d_ap_entry :: Desc -> InstrId
d_ap_entry (Desc e _ _) = e

d_arity    :: Desc -> Arity
d_arity (Desc _ a _) = a

d_name     :: Desc -> String
d_name (Desc _ _ n) = n

:: DescStore :== [Desc]

ds_get     :: DescId DescStore -> Desc
ds_get 0 [d:_] = d
ds_get _ []    = abortn "ds_get: index too large"
ds_get i [_:s] = ds_get (i-1) s

ds_init    :: [Desc] -> DescStore
ds_init ds = ds

:: GraphStore = { nodes :: [Node]
                , free  :: Int
                }

show_graphstore :: GraphStore DescStore -> String
show_graphstore {nodes,free} ds = show_nds (free+1) nodes ds
where
	show_nds :: Int [Node] [Desc] -> String
	show_nds i [] ds = ""
	show_nds i [n:ns] ds
		= i <+ " : " <+ show_nd n ds <+ "\n" <+ show_nds (i+1) ns ds

	show_nd :: Node [Desc] -> String
	show_nd (Basic _ e b) _  = e <+ " " <+ b
	show_nd (Node d e a)  ds = d_name (ds_get d ds) <+ " " <+ e <+ " [" <++ (",", a) <+ "]"
	show_nd Empty         _  = "Empty"

gs_get     :: NodeId GraphStore -> Node
gs_get i {nodes,free} = get (i-free-1) nodes
where
	get :: NodeId [Node] -> Node
	get 0 [n:_] = n
	get _ []    = abortn ("gs_get: index " <+ i <+ " too large for " <+ length nodes <+ " node(s)")
	get i [_:s] = get (i-1) s

gs_init    :: GraphStore
gs_init = {nodes=[], free=STORE_SIZE}

gs_newnode :: GraphStore -> (GraphStore, NodeId)
gs_newnode {free=0} = abortn "gs_newnode: graph store is full"
gs_newnode {nodes,free} = ({nodes=[Empty:nodes], free=free-1}, free)

gs_update  :: NodeId (Node -> Node) GraphStore -> GraphStore
gs_update i f gs=:{nodes,free}
| place <= STORE_SIZE-free = {gs & nodes=update place nodes f}
| otherwise                = abortn "gs_update: nodeid nonexistant"
where
	place = i - free - 1

	update :: Int [Node] (Node -> Node) -> [Node]
	update 0 [n:s] f = [f n:s]
	update i [n:s] f = [n:update (i-1) s f]
