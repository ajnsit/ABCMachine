implementation module ABC.GraphStore

import StdEnv

import ABC.Machine

:: GraphStore = { nodes :: [Node]
                , free  :: Int
                }

STORE_SIZE :== 1000

gs_get     :: NodeId GraphStore -> Node
gs_get i {nodes} = get i nodes
where
	get :: NodeId [Node] -> Node
	get 0 [n:_] = n
	get _ []    = abortn "gs_get: index too large"
	get i [_:s] = gs_get (i-1) s

gs_init    :: GraphStore
gs_init = {nodes=[], free=STORE_SIZE}

gs_newnode :: GraphStore -> (GraphStore, NodeId)
gs_newnode {free=:0} = abortn "gs_newnode: graph store is full"
gs_newnode {nodes,free} = ({nodes=[Empty:nodes], free=free-1}, free)

gs_update  :: NodeId (Node -> Node) GraphStore -> GraphStore
gs_update i f gs=:{nodes,free}
| place <= STORE_SIZE-free = {gs & nodes=update place nodes f}
| otherwise                = abortn "gs_update: nodeid nonexistant"
where
	place = i - free - 1

	update :: Int [Node] (Node -> Node) -> [Node]
	update 0 [n:s] f = [f n:s]
	update i [n:s] f = [n:update (i-1) f s]
