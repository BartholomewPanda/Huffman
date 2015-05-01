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

module Make (Sym : sig type t end) = struct

    module PriorityQueue = Set.Make (struct
        type t = (int * Sym.t Tree.t)
        let compare = compare
    end)

    let count size data =
        let table = Hashtbl.create size in
        let count sym =
            match Hashtbl.find table sym with
                | freq                -> Hashtbl.replace table sym (freq + 1)
                | exception Not_found -> Hashtbl.add table sym 1
        in
        Stream.iter count data;
        table

    let build_tree freq =
        let rec build queue =
            if PriorityQueue.cardinal queue = 1 then
                let _, tree = PriorityQueue.min_elt queue in
                tree
            else
                let freq1, subtree1 = PriorityQueue.min_elt queue in
                let queue = PriorityQueue.remove (freq1, subtree1) queue in
                let freq2, subtree2 = PriorityQueue.min_elt queue in
                let queue = PriorityQueue.remove (freq2, subtree2) queue in
                let tree = (freq1 + freq2, Tree.merge subtree1 subtree2) in
                build (PriorityQueue.add tree queue)
        in
        let leaves = Hashtbl.fold (fun s f l -> (f, Tree.leaf s) :: l) freq [] in
        let queue = PriorityQueue.of_list leaves in
        build queue

    let build_lookup_table size tree =
        let table = Hashtbl.create size in
        Tree.iter_leaves tree (fun path sym -> Hashtbl.add table sym path);
        table

    let compress lookup_table data =
        let convert _ =
            match Stream.next data with
                | sym                      -> Some (Hashtbl.find lookup_table sym)
                | exception Stream.Failure -> None
        in
        Stream.from convert

    let compress ?(size=256) data =
        let stream1, stream2 = Utils.stream_tee data in
        let freq = count size stream1 in
        let tree = build_tree freq in
        let lookup_table = build_lookup_table size tree in
        (tree, compress lookup_table stream2)

    let decompress tree data =
        let convert _ =
            match Stream.next data with
                | path                     -> Some (Tree.search_leaf tree path)
                | exception Stream.Failure -> None
        in
        Stream.from convert

end
