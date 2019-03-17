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

let rev_tab (xs : string list) : string list =
    let tab = "\t" in
    let rec loop accu = function
        | (x::xs) -> loop ((tab ^ x)::accu) xs
        | [] -> accu in
    loop [] xs
