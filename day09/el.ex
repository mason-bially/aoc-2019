Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day07/el.ex", __DIR__)

defmodule Day09 do
  def parameter_mode_relative(index) do
    fn
      (%{memory: memory, pc: pointer, rbase: rbase}, :get) ->
        addr = :array.get(pointer + index, memory) + rbase
        if addr > :array.size(memory), do: 0, else: :array.get(addr, memory)
      (%{memory: memory, pc: pointer, rbase: rbase}, {:set, value}) ->
        addr = :array.get(pointer + index, memory) + rbase
        :array.set(addr, value, memory)
    end
  end

  def decode_instruction_length(opcode) do
    case opcode do
      9 -> 2
      _ -> Day05.decode_instruction_length(opcode)
    end
  end

  def decode_parameter_mode(mode, index) do
    case mode do
      2 -> parameter_mode_relative(index)
      _ -> Day05.decode_parameter_mode(mode, index)
    end
  end

  def execute_instruction({%{memory: _, pc: pointer, rbase: rbase} = program, instruction}) do
    case instruction do
      {9, [a | _]} -> %{program |
        rbase: rbase + a.(program, :get),
        pc: pointer + 2
      }
      inst -> Day05.execute_instruction_b({program, inst})
    end
  end

  def run_program(program) do
    case program do
      %{pc: nil} -> program
      %{memory: _, pc: _, rbase: _, io: _} ->
        program
        |> Day05.fetch_instruction
        |> Day05.decode_opcode(&decode_instruction_length/1)
        |> Day05.decode_parameters(&decode_parameter_mode/2)
        |> execute_instruction
        |> run_program
      %{memory: memory, io: io} ->
        run_program(%{memory: memory, io: io, pc: 0, rbase: 0})
    end
  end
end
