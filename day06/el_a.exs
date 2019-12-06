Code.require_file("el.ex", __DIR__)

File.stream!("day06/input.txt", [encoding: :utf8], :line)
|> Stream.map(&Day06.parse_orbit/1)
|> Enum.reduce(%{}, &Day06.insert_orbit(&2, &1))
|> Day06.objects_set_orbit_depth
|> Map.values
|> Stream.map(fn o -> o.depth end)
|> Enum.sum
|> IO.inspect # 234446
