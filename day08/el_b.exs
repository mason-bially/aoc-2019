Code.require_file("el.ex", __DIR__)

defmodule Day08.B do

end

width = 25
height = 6
layer_size = width * height

strs =
  File.stream!("day08/input.txt", [encoding: :utf8], 1)
  |> Stream.filter(fn c -> c >= "0" and c <= "9" end)
  |> Stream.map(&elem(Integer.parse(&1), 0))
  |> Stream.chunk_every(layer_size)
  |> Enum.reduce(List.duplicate(2, layer_size), fn layer, acc ->
    Enum.zip(layer, acc)
    |> Enum.map(fn {lv, av} ->
      cond do
        av != 2 -> av
        true -> lv
      end
    end)
  end)
  |> Stream.map(fn c ->
    case c do
      1 -> "*"
      0 -> " "
    end
  end)
  |> Stream.chunk_every(25)
  |> Stream.map(fn l ->
    Enum.reduce(Enum.reverse(l), "", &<>/2)
  end)
  |> Enum.to_list

for s <- strs do
  IO.puts(s)
end
