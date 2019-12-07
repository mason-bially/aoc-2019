Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day05/el.ex", __DIR__)

defmodule Day07 do
  def spawn_program(parent, runner) do
    spawn fn ->
      receive do {:init, program} -> program end
      |> runner.()
      |> Util.result_send(parent, :halt)
    end
  end

  def simple_msg_io(output_pid, prefix_input \\ []) do
    %{
      prefix_input: prefix_input,
      input: fn
        %{prefix_input: []} = io ->
          {receive do {:value, value} -> value end, io}
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
