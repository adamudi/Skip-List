(*
Adam Udi
SkipList Implementation
*)

staload "SkipList.sats"
(*

fun nodeArr_create (l: int): nodeArr
fun nodeArr_get(na: nodeArr, i: int): node // get a node at specified index, return void if out of bounds
fun nodeArr_set(na: nodeArr, i: int, n:node): void // set index i in nodeArr na to node n

(* ****** ****** *)

fun node_create(k:int): node 
fun node_getArr(n: node): nodeArr // get the array in this node 
fun node_getKey(n: node): int // get the Key
fun node_getLevel(n: node): int // get Level
fun node_cmp(n1: node, n2: node): int // return -1 if n1 < n2, 0 if they are the same, and 1 if n2 > n1
fun node_cmp_key(n1: node, k: int): int // same as node compare, but only comparing key values
fun node_chooseHeight(maxHeight: int, r: myRandom): int // choose a height for this node

(* ****** ****** *) 

fun list_insert(n: node, ins: node, n1: node, l: int): void // insert ins in between n and n1 at level l

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

*)

(*** Node Operations ***)

//
// Using randomness choose a height up to max height

implement node_chooseHeight(max, r) = 
let 
  fun node_chooseHeight_help(r: myRandom): int =
    let
      val bit = randomBit(r)
    in
      if bit = 1 then node_chooseHeight_help(r) + 1 else 0
    end
  val height = node_chooseHeight_help(r) + 1
in
  if height <= max then height else max
end

(*** Helper functions for list operations ***)

//
// Insert a node in between two others in a linked list
//

implement list_insert_l(n, ins, n1, l) =
let
  val na = node_getArr(n)
  val insa = node_getArr(ins)
  val () = nodeArr_set(na, l, ins)  
  val () = nodeArr_set(insa, l, n1)
in
end

//
// Remove a node from between two others 
// with invariant that there is one node 
// between n1 and n3 that we want removed
//

implement list_delete_l(n1, n3, l) =
let
  val n1a = node_getArr(n1)
  val () = nodeArr_set(n1a, l, n3)
in
end

(*** List Operations ***)

//
// deletion by key
//

implement SkipList_delete(sk, key) =
let
  fun SkipList_delete_l
  (sk: SkipList, n: node, k: int, l: int): SkipList =
  let
    val na = node_getArr(n)
    val n1 = nodeArr_get(na, l)
    val cmp = node_cmp_key(n1, key)
  in
    if isFinalNode(n1) 
      then if l > 0 then SkipList_delete_l(sk, n, k, l - 1) else sk
    else
      if cmp = 0 then 
        let
          val n2 = nodeArr_get(node_getArr(n1), l)
          val () = list_delete_l(n, n2, l)
        in
          if l > 0 
          then SkipList_delete_l(sk, n, k, l - 1) else sk
        end
      else if cmp > 0 then
        if l > 0
        then SkipList_delete_l(sk, n, k, l - 1) else sk
      else if l > 0 then SkipList_delete_l(sk, n1, k, l) else sk
  end  
  val level = node_chooseHeight(SkipList_getMaxLevel(sk), random_create())
  val n = SkipList_getHead(sk)
in
  SkipList_delete_l(sk, n, key, level)
end

//
// insertion
//

implement SkipList_insert(sk, key) =
let
  fun SkipList_insert_l
  (sk: SkipList, n: node, ins: node,  l: int): SkipList = 
    let
      val na = node_getArr(n)
      val n1 = nodeArr_get(na, l)
      val cmp = node_cmp(ins, n1)
    in
      if isFinalNode(n1) then 
        let
          val () = list_insert_l(n, ins, n1, l) 
        in
          if l > 0 then SkipList_insert_l(sk, n, ins, l - 1) else sk  
        end
      else
        if cmp > 0 then 
          let
            val () = list_insert_l(n, ins, n1, l)
          in
            if l > 0 then SkipList_insert_l(sk, n, ins, l - 1) else sk
          end
        else if cmp < 0 then SkipList_insert_l(sk, n1, ins, l)
        else sk  
    end
  val level = node_chooseHeight(SkipList_getMaxLevel(sk), random_create())
  val ins = node_create(key)
  val n = SkipList_getHead(sk)
in
  SkipList_insert_l(sk, n, ins, level)
end

//
// search by key
//

implement SkipList_search(sk, k) = 
let
  fun SkipList_search_l
  (sk: SkipList, n: node, k: int, l: int): Option(node) =
    let 
      val n1 = nodeArr_get(node_getArr(n), l)
      val cmp = node_cmp_key(n1, k)
    in
      if cmp = 0 then Some(n1)
      else if cmp > 0 then 
        if l >= 0 then SkipList_search_l(sk, n, k, l - 1) else None ()
      else SkipList_search_l(sk, n1, k, node_getLevel(n1))
    end
  //
  val head = SkipList_getHead(sk)
  val level = node_getLevel(head)    
  //
in
  SkipList_search_l(sk, head, k, level)
end