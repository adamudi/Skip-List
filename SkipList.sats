(* 

Adam Udi
CS520 Final Assignment
SkipList Implementation
  
*)

staload "prelude/DATS/option.dats"

(* ****** ****** *) 

abstype nodeArr // to represent all forward pointers
abstype node // to represent a key, value pair and forward pointers
abstype myRandom // to represent randomness
datatype SkipList = | SkipList of(int,node)

(* ****** ****** *) 

fun nodeArr_create (l: int): nodeArr
fun nodeArr_get(na: nodeArr, i: int): node // get a node at specified index, return void if out of bounds
fun nodeArr_set(na: nodeArr, i: int, n:node): void // set index i in nodeArr na to node n

(* ****** ****** *)

fun list_insert_l(n: node, ins: node, n1: node, l: int): void // insert ins in between n and n1 at level l
fun list_delete_l(n1: node, n3: node, l: int): void // remove node from in between nodes n1 and n3 at level l
fun isFinalNode(n1: node): bool 

(* ****** ****** *)

fun node_create(k:int): node 
fun node_getArr(n: node): nodeArr // get the array in this node 
fun node_getKey(n: node): int // get the Key
fun node_getLevel(n: node): int // get Level
fun node_cmp(n1: node, n2: node): int // return -1 if n1 < n2, 0 if they are the same, and 1 if n2 > n1
fun node_cmp_key(n1: node, k: int): int // same as node compare, but only comparing key values
fun node_chooseHeight(maxHeight: int, r: myRandom): int // choose a height for this node

(* ****** ****** *) 

fun random_create(): myRandom // new random object
fun randomBit(r: myRandom): int // return a random bit 0 or 1

(* ****** ****** *) 
 
fun SkipList_create(maxLevel: int): SkipList // create empty skip list with max level
fun SkipList_getHead(sk: SkipList): node // get head of list
fun SkipList_getMaxLevel(sk: SkipList): int // get max level
fun SkipList_search(sk: SkipList, key: int): Option(node) // search for a key return a node 
fun SkipList_insert(sk: SkipList, key: int): SkipList // insert a node with a new key
fun SkipList_delete(sk: SkipList, key: int): SkipList // delete node with key

(* ****** ****** *) 