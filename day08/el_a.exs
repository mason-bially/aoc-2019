Code.require_file("el.ex", __DIR__)

defmodule Day08.A do

end

width = 25
height = 6
layer_size = width * height

File.stream!("day08/input.txt", [encoding: :utf8], 1)
|> Stream.filter(fn c -> c >= "0" and c <= "9" end)
|> Stream.map(&elem(Integer.parse(&1), 0))
|> Stream.chunk_every(layer_size)
|> Stream.map(fn layer ->
  {Enum.count(layer, fn c -> c == 0 end), layer}
end)
|> Enum.sort_by(&elem(&1, 0))
|> Enum.take(1)
|> Enum.map(fn {_, layer} ->
  {Enum.count(layer, fn c -> c == 1 end) * Enum.count(layer, fn c -> c == 2 end), layer}
end)
|> IO.inspect
