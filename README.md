Generic Huffman Coding
======================

Here is a simple implementation of the Huffman coding. This one can build a
Huffman tree with any kind of symbols. In most cases, the tree is built
with byte (a tree leaf is a byte) but you can build the tree with other
symbols (e.g: n-grams, integers, words, pictures, etc.)

I developped this project to try different configurations of the Huffman coding
and especially to study the results of compression using different kinds of
symbols.

How to use the library:
-----------------------

Firstly, you have to write a module. For example, if you want to build a
Huffman tree on a byte stream:
```
module Char = struct
    type t = char
end
```

Secondly, make a new Huffman tree of Char:
```
module CharHuffman = Huffman.Make (Char)
```

Now, you can build a tree and a compressed data stream:
```
let str = "une chaine de caractères" in
let stream = Stream.of_string str in
let tree, compressed_stream = CharHuffman.compress stream
```

`compressed_stream` is a stream of bits. You can read/store/... them.

Henceforth, if you want to decompress a stream of bits and display decoded
characters:
```
Stream.iter (Printf.printf "%c") decompressed_stream;
Printf.printf "\n"
```

More examples are in `./examples/`

TODO list:
----------

For the moment, you can build a Huffman tree, a compressed data stream and a
decompressed data stream.

Here is the todo list:
- manage the special case where the tree has only one node
- write a method to serialize the tree
- convert into a Huffman template algorithm
- write function to store/load into/from file

