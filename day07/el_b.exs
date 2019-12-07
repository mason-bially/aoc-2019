Code.require_file("el.ex", __DIR__)

program_memory = Day02.read_intcode("day07/input.txt")

5..9
|> Enum.to_list
|> Util.permutations
|> Enum.reduce({0, nil}, fn phases, {best_value, _} = acc ->
  res = Day07.run_amplifiers_feedback(program_memory, phases, 0)
  if res > best_value do
    {res, phases}
  else
    acc
  end
end)
|> IO.inspect
