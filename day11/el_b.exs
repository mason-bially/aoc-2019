Code.require_file("el.ex", __DIR__)

end_state = Day09.run_program(%{
  memory: Day02.read_intcode("day11/input.txt"),
  io: Day11.hull_robot_io(Map.put(%{}, {0, 0}, 1))
})

panels = end_state.io.panels
{min_x, max_x} = Map.keys(panels)
|> Stream.map(&elem(&1, 0))
|> Enum.min_max
{min_y, max_y} = Map.keys(panels)
|> Stream.map(&elem(&1, 1))
|> Enum.min_max

for y <- max_y..min_y do
  for x <- min_x..max_x do
    case Map.get(panels, {x, y}, 0) do
      0 -> "  "
      1 -> "##"
    end
  end
  |> Enum.reduce("", &(&2 <> &1))
  |> IO.puts
end
