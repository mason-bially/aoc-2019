Code.require_file("el.ex", __DIR__)

map =
  File.stream!("day06/input.txt", [encoding: :utf8], :line)
  |> Stream.map(&Day06.parse_orbit/1)
  |> Enum.reduce(%{}, &Day06.insert_orbit(&2, &1))
  |> Day06.objects_set_orbit_depth

src_orbit_list = Day06.orbit_list(map, "YOU")
dst_orbit_list = Day06.orbit_list(map, "SAN")

trasfer_orbit =
  Enum.zip(Enum.reverse(src_orbit_list), Enum.reverse(dst_orbit_list))
  |> Stream.take_while(fn {a, b} -> a == b end)
  |> Enum.at(-1)
  |> elem(0)

IO.inspect(trasfer_orbit)

tns_depth = Map.fetch!(map, trasfer_orbit).depth
you_depth = Map.fetch!(map, "YOU").depth - tns_depth - 1
san_depth = Map.fetch!(map, "SAN").depth - tns_depth - 1

IO.inspect(you_depth + san_depth)
