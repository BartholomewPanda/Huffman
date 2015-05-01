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

(*
 * Description:
 * Just a simple example.
 *)

module Char = struct
    type t = char
end

module CharHuffman = Huffman.Make (Char)

let str =
"Je le répète, ce que nous reprochons avant tout à la peine de mort, c'est \
qu'elle limite, concentre la responsabilité de la peine de mort. C'est dans \
la race humaine l'absolu de la peine. Eh bien ! Nous n'avons pas le droit de \
prononcer l'absolu de la peine parce que nous n'avons pas le droit de faire \
porter sur une seule tête l'absolu de la responsabilité."

let _ = begin
    (* Build the Huffman tree and make a new compressed stream *)
    let stream = Stream.of_string str in
    let tree, compressed_stream = CharHuffman.compress stream in

    (* Build a new decompressed stream *)
    let decompressed_stream = CharHuffman.decompress tree compressed_stream in

    (* Display decompressed data *)
    Stream.iter (Printf.printf "%c") decompressed_stream;
    Printf.printf "\n"
end

