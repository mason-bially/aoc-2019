Code.require_file("el.ex", __DIR__)

defmodule Day07.B do
  def amplifier_feedback_loop(parent, begin, count_left) do
    receive do
      {:begin, begin, init_value} ->
        send begin, {:value, init_value}
        amplifier_feedback_loop(parent, begin, count_left)
      {:value, value} when count_left == 1 ->
        send parent, {:value, value}
      {:value, value} ->
        send begin, {:value, value}
        amplifier_feedback_loop(parent, begin, count_left)
      {:halt} ->
        amplifier_feedback_loop(parent, begin, count_left - 1)
    end
  end

  def run_amplifiers_feedback(init_memory, phase_settings, init_value) do
    this = self()
    feedbacker = spawn(fn -> amplifier_feedback_loop(this, nil, Enum.count(phase_settings)) end)
    begin =
      Enum.reduce(Enum.reverse(phase_settings), feedbacker,
        fn phase_setting, target ->
          spawn(fn ->
            io = Day07.simple_msg_io(target, [phase_setting])

            Day05.run_program(%{memory: init_memory, pc: 0, io: io})
            send feedbacker, {:halt}
          end)
        end)
    send feedbacker, {:begin, begin, init_value}
    receive do
      {:value, value} -> value
    end
  end
end


program_memory = Day02.read_intcode("day07/input.txt")

5..9
|> Enum.to_list
|> Util.permutations
|> Enum.reduce({0, nil}, fn phases, {best_value, _} = acc ->
  res = Day07.B.run_amplifiers_feedback(program_memory, phases, 0)
  if res > best_value, do: {res, phases}, else: acc
end)
|> IO.inspect
# 17279674
