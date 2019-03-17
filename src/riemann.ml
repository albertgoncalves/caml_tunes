(* https://en.wikipedia.org/wiki/Neo-Riemannian_theory *)

module D = Data
module L = List
module P = Printf
module R = Random
module S = String
module U = Utils

let int_to_move : (int -> string option) = function
    | 0 -> Some "P"
    | 1 -> Some "R"
    | 2 -> Some "L"
    | _ -> None

let move (chord : D.chord) : (string option -> D.chord) = function
    | Some "P" ->
        begin
            match D.tonality chord with
                | Some "major" ->
                    { first = chord.first
                    ; third = chord.third - 1
                    ; fifth = chord.fifth
                    }
                | Some "minor" ->
                    { first = chord.first
                    ; third = chord.third + 1
                    ; fifth = chord.fifth
                    }
                | _ -> chord
        end
    | Some "R" ->
        begin
            match D.tonality chord with
                | Some "major" ->
                    { first = chord.fifth + 2
                    ; third = chord.first
                    ; fifth = chord.third
                    }
                | Some "minor" ->
                    { first = chord.third
                    ; third = chord.fifth
                    ; fifth = chord.first - 2
                    }
                | _ -> chord
        end
    | Some "L" ->
        begin
            match D.tonality chord with
                | Some "major" ->
                    { first = chord.third
                    ; third = chord.fifth
                    ; fifth = chord.first - 1
                    }
                | Some "minor" ->
                    { first = chord.fifth + 1
                    ; third = chord.first
                    ; fifth = chord.third
                    }
                | _ -> chord
        end
    | _ -> chord

let ints_to_chords (chord : D.chord) (ns : int list) : D.chord list =
    let rec loop (chord : D.chord) (accu : D.chord list)
        : (int list -> D.chord list) = function
        | (n::ns) ->
            loop (move chord (int_to_move n) |> D.center) (chord::accu) ns
        | [] -> (chord::accu) in
    loop chord [] ns

let main () =
    let ns = L.init 25 (fun _ -> R.int 3) in
    let message = "unable to construct initial chord" in
    let root = int_of_string Sys.argv.(1) in
    let tonality = Sys.argv.(2) in
    let chord = D.construct root tonality in
    let notes =
        match chord with
            | Some chord ->
                chord
                |> D.center
                |> begin
                    fun chord ->
                        P.sprintf
                            "notes = %d %d %d"
                            chord.first
                            chord.third
                            chord.fifth
                end
            | None -> "unknown notes" in
    let chords =
        match chord with
            | Some chord ->
                begin
                    match D.tonality chord with
                        | Some "major" | Some "minor" ->
                            ints_to_chords chord ns
                            |> L.map D.chord_to_string
                            |> U.rev_tab
                            |> S.concat "\n"
                        | Some tonality ->
                            P.sprintf
                                "no progressions prepared for %s chords"
                                tonality
                        | _ -> message
                end
            | None -> message in
    L.iter
        print_endline
        [ P.sprintf "./riemann %d %s" root tonality
        ; notes
        ; "chords ="
        ; chords
        ]

let () = main ()
