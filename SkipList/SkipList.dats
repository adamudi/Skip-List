(*
Adam Udi
SkipList Implementation
*)

staload "SkipList.sats"
(*
typedef SkipList = @{maxLevel = int, head = node}

fun nodeArr_create (): nodeArr
fun nodeArr_get(na: nodeArr, i: int): node // get a node at specified index, return void if out of bounds

(* ****** ****** *)

fun node_create(k:int): node 
fun node_getArr(n: node): nodeArr // get the array in this node 
fun node_getKey(n: node): int // get the Key
fun node_getLevel(n: node): int // get Level
fun node_cmp(n1: node, n2: node): int // return -1 if n1 < n2, 0 if they are the same, and 1 if n2 > n1
fun node_cmp_key(n1: node, k: int): int // same as node compare, but only comparing key values
fun node_chooseHeight(maxHeight: int, r: myRandom): int // choose a height for this node

(* ****** ****** *) 

fun randomBit(r: myRandom): int // return a random bit 0 or 1

(* ****** ****** *) 
 
fun SkipList_create(maxLevel: int): SkipList // create empty skip list with max level
fun SkipList_getHead(sk: SkipList): node // get head of list
fun SkipList_getMaxLevel(sk: SkipList): int // get max level
fun SkipList_search(sk: SkipList, key: int): node // search for a key return a node 
fun SkipList_insert(sk: SkipList, key: int): SkipList // insert a node with a new key
fun SkipList_delete(sk: SkipList, key: int): SkipList // delete node with key

*)

implement SkipList_search(sk, k) =
let
  fun SkipList_search_l
  (sk: SkipList, n: node, k: int, l: int): node =
    let 
      val n1 = nodeArr_get(node_getArr(n), l)
      val cmp = node_cmp_key(n1, k)
    in
      if cmp = 0 then n1
      else if cmp > 0 then SkipList_search_l(sk, n, k, l - 1)
      else SkipList_search_l(sk, n1, k, node_getLevel(n1))
    end
  //
  val head = SkipList_getHead(sk)
  val level = node_getLevel(head)    
  //
in
  SkipList_search_l(sk, head, k, level)
end