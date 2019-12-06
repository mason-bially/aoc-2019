Code.require_file("el.ex", __DIR__)

[a, b] =
  Day03.read_paths("day03/input.txt")
  |> Stream.map(&Day03.path_to_coords(&1))
  |> Stream.map(&Day03.coords_to_segments/1)
  |> Enum.to_list()

(for i <- a, j <- b, do: {i, j})
|> Stream.map(fn {a, b} -> Day03.intersect_segments(a, b) end)
|> Stream.reject(&is_nil/1)
|> Stream.map(&Day03.manhatten_distance({0, 0}, &1))
|> Enum.sort
|> IO.inspect
