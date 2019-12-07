Code.require_file("el.ex", __DIR__)

program_memory = Day02.read_intcode("day07/input.txt")

0..4
|> Enum.to_list
|> Util.permutations
|> Enum.reduce({0, nil}, fn phases, {best_value, _} = acc ->
  res = Day07.run_amplifiers(program_memory, phases, 0)
  if res > best_value do
    {res, phases}
  else
    acc
  end
end)
|> IO.inspect
