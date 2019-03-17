(* https://en.wikipedia.org/wiki/Neo-Riemannian_theory *)

module L = List
module P = Printf
module R = Random
module S = String

type chord =
    { first : int
    ; third : int
    ; fifth : int
    }

let mod12 (x : int) : int =
    x
    |> (fun x -> x mod 12)
    |> begin
        fun x ->
            if x < 0 then
                x + 12
            else
                x
    end

let center (chord : chord) : chord =
    { first = mod12 chord.first
    ; third = mod12 chord.third
    ; fifth = mod12 chord.fifth
    }

let tonality (chord : chord) : string option =
    let third = chord.third - chord.first |> mod12 in
    let fifth = chord.fifth - chord.first |> mod12 in
    match (third, fifth) with
        | (3, 6) -> Some "diminished"
        | (3, 7) -> Some "minor"
        | (4, 7) -> Some "major"
        | (4, 8) -> Some "augmented"
        | _ -> None

let int_to_move : (int -> string option) = function
    | 0 -> Some "P"
    | 1 -> Some "R"
    | 2 -> Some "L"
    | _ -> None

let move (chord : chord) : (string option -> chord) = function
    | Some "P" ->
        begin
            match tonality chord with
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
            match tonality chord with
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
            match tonality chord with
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

let note_to_string : (int -> string option) = function
    | 0 -> Some "C"
    | 1 -> Some "C#/Db"
    | 2 -> Some "D"
    | 3 -> Some "D#/Eb"
    | 4 -> Some "E"
    | 5 -> Some "F"
    | 6 -> Some "F#/Gb"
    | 7 -> Some "G"
    | 8 -> Some "G#/Ab"
    | 9 -> Some "A"
    | 10 -> Some "A#/Bb"
    | 11 -> Some "B"
    | _ -> None

let chord_to_string (chord : chord) : string =
    let note =
        chord.first
        |> mod12
        |> note_to_string in
    let tonality = tonality chord in
    match (note, tonality) with
        | (Some note, Some tonality) ->
            P.sprintf "%s %s" note tonality
        | _ ->
            P.sprintf "%d %d %d"
                chord.first
                chord.third
                chord.fifth

let construct (first : int) : (string -> chord option) = function
    | "diminished" ->
        Some
            { first = first
            ; third = first + 3
            ; fifth = first + 6
            }
    | "minor" ->
        Some
            { first = first
            ; third = first + 3
            ; fifth = first + 7
            }
    | "major" ->
        Some
            { first = first
            ; third = first + 4
            ; fifth = first + 7
            }
    | "augmented" ->
        Some
            { first = first
            ; third = first + 4
            ; fifth = first + 8
            }
    | _ -> None

let int_to_move (chord : chord) (n : int) : chord = move chord (int_to_move n)

let ints_to_chords (chord : chord) (ns : int list) : chord list =
    let rec loop (chord : chord) (accu : chord list)
        : (int list -> chord list) = function
        | (n::ns) -> loop (int_to_move chord n) (chord::accu) ns
        | [] -> (chord::accu) in
    loop chord [] ns

let main () =
    let ns = L.init 25 (fun _ -> R.int 3) in
    let message = "unable to construct initial chord" in
    construct 0 "major"
    |> begin function
        | Some chord ->
            begin
                match tonality chord with
                    | Some "major" | Some "minor" ->
                        ints_to_chords chord ns
                        |> L.map chord_to_string
                        |> L.rev
                        |> S.concat "\n"
                    | Some tonality ->
                        P.sprintf
                            "no progressions prepared for %s chords"
                            tonality
                    | _ -> message
            end
        | None -> message
    end
    |> print_endline

let () = main ()
