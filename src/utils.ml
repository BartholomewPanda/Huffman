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

let stream_tee stream =
    let next self other _ =
        try
            if Queue.is_empty self then
                let value = Stream.next stream in
                Queue.add value other;
                Some value
            else
                Some (Queue.take self)
        with Stream.Failure -> None
    in
    let q1 = Queue.create () in
    let q2 = Queue.create () in
    (Stream.from (next q1 q2), Stream.from (next q2 q1))

