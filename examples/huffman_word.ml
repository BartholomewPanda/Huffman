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
 * Application of the Huffman coding to words. In this example, the algorithm
 * builds a tree whose leaves are words (rather than characters).
 *)

module Word = struct
    type t = string
end

module WordHuffman = Huffman.Make (Word)

(*
 * Naive word tokenizer. It converts a stream of characters into a
 * stream of words by using space character.
 *)
let to_word_stream stream =
    let to_string l = String.concat "" (List.rev (" " :: l)) in
    let rec get_word result =
        match Stream.next stream with
            | ' '                      -> Some (to_string result)
            | c                        -> get_word (Char.escaped c :: result)
            | exception Stream.Failure -> if result = [] then None
                                          else Some (to_string result)
    in
    let next_word _ = get_word [] in
    Stream.from next_word

let str =
"Je le répète, ce que nous reprochons avant tout à la peine de mort, c'est \
qu'elle limite, concentre la responsabilité de la peine de mort. C'est dans \
la race humaine l'absolu de la peine. Eh bien ! Nous n'avons pas le droit de \
prononcer l'absolu de la peine parce que nous n'avons pas le droit de faire \
porter sur une seule tête l'absolu de la responsabilité."

let _ = begin
    Printf.printf "Original string:\n%s\n\n" str;

    (* Build the Huffman tree and make a new compressed stream *)
    let stream = to_word_stream (Stream.of_string str) in
    let tree, compressed_stream = WordHuffman.compress stream in

    (* Display compressed data *)
    let compressed_stream, compressed_stream_copy = Utils.stream_tee compressed_stream in
    Printf.printf "Compressed stream (bits):\n";
    Stream.iter (List.iter (Printf.printf "%d")) compressed_stream_copy;
    Printf.printf "\n\n";

    (* Build a new decompressed stream *)
    let decompressed_stream = WordHuffman.decompress tree compressed_stream in

    (* Display decompressed data *)
    Printf.printf "Decompressed stream:\n";
    Stream.iter (Printf.printf "%s") decompressed_stream;
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
