Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day05/el.ex", __DIR__)

defmodule Day07 do
  def run_amplifiers(init_memory, phase_settings, init_value) do
    Enum.reduce(phase_settings, init_value,
      fn phase_setting, previous_value ->
        io = %{
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

        Day05.run_program(%{memory: init_memory, pc: 0, io: io}).io.result
      end)
  end

  def amplifier_feedback_loop(parent, begin, count_left) do
    receive do
      {:begin, begin, init_value} ->
        IO.inspect("begin #{count_left}")
        send begin, {:value, init_value}
        amplifier_feedback_loop(parent, begin, count_left)
      {:value, value} when count_left == 1 ->
        IO.inspect("ending value")
        send parent, {:value, value}
      {:value, value} ->
        IO.inspect("feeback value")
        send begin, {:value, value}
        amplifier_feedback_loop(parent, begin, count_left)
      {:halt} ->
        IO.inspect("Halting #{count_left}")
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
            io = %{
              phase: phase_setting,
              result: nil,
              input: fn
                %{phase: nil} = io ->
                  r = {receive do {:value, value} -> value end, io}
                  r
                %{phase: phase} = io ->
                  {phase, %{io | phase: nil}}
              end,
              output: fn io, value ->
                send target, {:value, value}
                io
              end
            }

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
