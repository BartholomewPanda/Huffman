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
 * Simple implementation of the basic Huffman coding. Each character is
 * compressed (leaves of the tree are characters).
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
    Printf.printf "Original string:\n%s\n\n" str;

    (* Build the Huffman tree and make a new compressed stream *)
    let stream = Stream.of_string str in
    let tree, compressed_stream = CharHuffman.compress stream in

    (* Display compressed data *)
    let compressed_stream, compressed_stream_copy = Utils.stream_tee compressed_stream in
    Printf.printf "Compressed stream (bits):\n";
    Stream.iter (List.iter (Printf.printf "%d")) compressed_stream_copy;
    Printf.printf "\n\n";

    (* Build a new decompressed stream *)
    let decompressed_stream = CharHuffman.decompress tree compressed_stream in

    (* Display decompressed data *)
    Printf.printf "Decompressed stream:\n";
    Stream.iter (Printf.printf "%c") decompressed_stream;
    Printf.printf "\n\n";

    (* Display some information *)
    let uncompressed_size = String.length str * 8 in
    let compressed_size = Stream.count compressed_stream in
    let ratio =
        (float_of_int uncompressed_size) /. (float_of_int compressed_size)
    in
    Printf.printf "Size of uncompressed string: %d bits\n" uncompressed_size;
    Printf.printf "Size of compressed string: %d bits\n" compressed_size;
    Printf.printf "Ratio: %f\n" ratio
end

