module U = Utils
module P = Printf

type chord =
    { first : int
    ; third : int
    ; fifth : int
    }

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

let center (chord : chord) : chord =
    { first = U.mod12 chord.first
    ; third = U.mod12 chord.third
    ; fifth = U.mod12 chord.fifth
    }

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

let tonality (chord : chord) : string option =
    let third = chord.third - chord.first |> U.mod12 in
    let fifth = chord.fifth - chord.first |> U.mod12 in
    match (third, fifth) with
        | (3, 6) -> Some "diminished"
        | (3, 7) -> Some "minor"
        | (4, 7) -> Some "major"
        | (4, 8) -> Some "augmented"
        | _ -> None

let chord_to_string (chord : chord) : string =
    let note =
        chord.first
        |> U.mod12
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
