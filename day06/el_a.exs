Code.require_file("el.ex", __DIR__)

File.stream!("day06/input.txt", [encoding: :utf8], :line)
|> Stream.map(&Day06.parse_orbit/1)
|> Enum.reduce(%{"COM": {MapSet.new(), 0}}, &Day06.insert_orbit(&2, &1))
|> Day06.objects_set_orbit_count
|> Map.values
|> Stream.map(&elem(&1, 1))
|> Enum.sum
|> IO.inspect
