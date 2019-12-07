Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day05/el.ex", __DIR__)

defmodule Day07 do
  def spawn_program(runner, halt_pid \\ self()) do
    spawn_link fn ->
      receive do {:init, program} -> program end
      |> runner.()
      |> Util.result_send(halt_pid, :halt)
    end
  end

  def simple_msg_io(output_pid, prefix_input \\ []) do
    %{
      prefix_input: prefix_input,
      input: fn
        %{prefix_input: []} = io ->
          r = {receive do {:value, value} -> value end, io}
          r
        %{prefix_input: [prefix | rest_prefix]} = io ->
          {prefix, %{io | prefix_input: rest_prefix}}
      end,
      output: fn io, value ->
        send(output_pid, {:value, value})
        io
      end
    }
  end
end
