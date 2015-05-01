(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*                   Bartholomew de La Villardière                     *)
(*                                                                     *)
(*                     http://www.bartholomew.fr/                      *)
(*                https://github.com/BartholomewPanda                  *)
(*                                                                     *)
(***********************************************************************)

type 'a t =
    | Node of ('a t * 'a t)
    | Leaf of 'a

let leaf value =
    Leaf value

let merge tree1 tree2 =
    Node (tree1, tree2)

let iter_leaves tree pred =
    let rec browse path = function
        | Leaf value          -> pred (List.rev path) value
        | Node (ltree, rtree) ->
            browse (0 :: path) ltree;
            browse (1 :: path) rtree
    in
    browse [] tree

let rec search_leaf tree path =
    match tree with
        | Leaf value          -> value
        | Node (ltree, rtree) ->
            let direction = List.hd path in
            let path = List.tl path in
            if direction = 0 then
                search_leaf ltree path
            else
                search_leaf rtree path

