Code.require_file("el.ex", __DIR__)

defmodule Day07.A do
  def amplifier_io(phase_setting, previous_value) do
    %{
      values: [phase_setting, previous_value],
      result: nil,
      input: fn io ->
        [head | tail] = io.values
        {head, %{io | values: tail}}
      end,
      output: fn io, value ->
        %{io | result: value}
      end
    }
  end

  def run_amplifier(init_memory, phase_setting, previous_value) do
    Day05.run_program(%{
      memory: init_memory, pc: 0,
      io: amplifier_io(phase_setting, previous_value)
    }).io.result
  end
end


program_memory = Day02.read_intcode("day07/input.txt")

0..4
|> Enum.to_list
|> Util.permutations
|> Enum.reduce({0, nil},
  fn phases, {best_value, _} = acc ->
    res = Enum.reduce(phases, 0, &Day07.A.run_amplifier(program_memory, &1, &2))
    if res > best_value, do: {res, phases}, else: acc
  end)
|> IO.inspect
# 87138
