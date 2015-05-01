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
 * Simple implementation of the n-gram compression with the Huffman coding.
 * In this example, n = 2 (bigram). The implementation is very basic (the
 * string must have an even size).
 *)

(* 2-gram *)
module Bigram = struct
    type t = (char * char)
end

module BigramHuffman = Huffman.Make (Bigram)

(*
 * Convert a stream of character into a stream of bigram.
 *)
let to_bigram_stream stream =
    let next_bigram _ =
        try
            let gram1 = Stream.next stream in
            let gram2 = Stream.next stream in
            Some (gram1, gram2)
        with Stream.Failure ->
            None
    in
    Stream.from next_bigram

let str = "abababzezezelololololololilili"

let _ = begin
    Printf.printf "Original string:\n%s\n\n" str;

    (* Build the Huffman tree and make a new compressed stream *)
    let stream = to_bigram_stream (Stream.of_string str) in
    let tree, compressed_stream = BigramHuffman.compress stream in

    (* Display compressed data *)
    let compressed_stream, compressed_stream_copy = Utils.stream_tee compressed_stream in
    Printf.printf "Compressed stream (bits):\n";
    Stream.iter (List.iter (Printf.printf "%d")) compressed_stream_copy;
    Printf.printf "\n\n";

    (* Build a new decompressed stream *)
    let decompressed_stream = BigramHuffman.decompress tree compressed_stream in

    (* Display decompressed data *)
    Printf.printf "Decompressed stream:\n";
    Stream.iter (fun (c1, c2) -> Printf.printf "%c%c" c1 c2) decompressed_stream;
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

