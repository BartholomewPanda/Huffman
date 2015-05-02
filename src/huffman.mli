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

module Make : functor (Sym : sig type t end) -> sig
    val compress :
        ?size:int -> Sym.t Stream.t -> Sym.t Tree.t * int list Stream.t
    val decompress :
        'a Tree.t -> int list Stream.t -> 'a Stream.t
end

