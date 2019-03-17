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
