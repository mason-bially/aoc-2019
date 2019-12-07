Code.require_file("el.ex", __DIR__)

defmodule Day07.B do
  def amplifier_feedback_loop(parent, front, count_left) do
    receive do
      {:init, front, init_value} ->
        send(front, {:value, init_value})
        amplifier_feedback_loop(parent, front, count_left)
      {:value, value} when count_left == 1 ->
        send(parent, {:value, value})
      {:value, value} ->
        send(front, {:value, value})
        amplifier_feedback_loop(parent, front, count_left)
      {:halt, _} ->
        amplifier_feedback_loop(parent, front, count_left - 1)
    end
  end

  def spawn_amplifier_feedback_loop(count, parent \\ self()) do
    spawn_link(fn -> amplifier_feedback_loop(parent, nil, count) end)
  end
end


program_memory = Day02.read_intcode("day07/input.txt")

5..9
|> Enum.to_list
|> Util.permutations
|> Enum.reduce({0, nil}, fn phases, {best_value, _} = acc ->
  feedbacker = Day07.B.spawn_amplifier_feedback_loop(Enum.count(phases))
  front =
    phases
    |> Enum.zip(Stream.repeatedly(fn -> Day07.spawn_program(&Day05.run_program/1, feedbacker) end))
    |> Stream.concat([{nil, feedbacker}])
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [{phase, amp}, {_, amp_next}] ->
      send(amp, {:init, %{memory: program_memory, pc: 0, io: Day07.simple_msg_io(amp_next, [phase])}})
      amp
    end)
    |> Enum.at(0)

  send(feedbacker, {:init, front, 0})
  res = receive do {:value, value} -> value end
  if res > best_value, do: {res, phases}, else: acc
end)
|> IO.inspect
# 17279674
