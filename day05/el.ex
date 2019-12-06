Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day02/el.ex", __DIR__)

defmodule Day05 do

  def parameter_mode_immediate(index) do
    fn
      (%{memory: memory, pc: pointer}, :get) -> :array.get(pointer + index, memory)
    end
  end

  def parameter_mode(mode, index) do
    case mode do
      0 -> Day02.parameter_mode_position(index)
      1 -> parameter_mode_immediate(index)
    end
  end

  def decode_instruction_length(opcode) do
    cond do
      opcode in [1, 2, 7, 8] -> 4
      opcode in [5, 6] -> 3
      opcode in [3, 4] -> 2
      opcode in [99] -> 1
    end
  end

  def decode_instruction_parameter_count(opcode) do
    decode_instruction_length(opcode) - 1
  end

  def decode_instruction_parameters(opcode, mode) do
    params = Enum.zip(
      1..decode_instruction_parameter_count(opcode),
      Stream.concat(Enum.reverse(Integer.digits(mode)), Stream.repeatedly(fn -> 0 end)))
    for {index, mode} <- params do
      parameter_mode(mode, index)
    end
  end

  def decode_instruction(%{memory: memory, pc: pointer} = program) do
    instruction = :array.get(pointer, memory)
    opcode = rem(instruction, 100)
    mode = div(instruction, 100)

    {
      program,
      {opcode, decode_instruction_parameters(opcode, mode)}
    }
  end

  def execute_instruction_a({%{memory: _, pc: pointer, io: {input, output}} = program, instruction}) do
    case instruction do
      {3, [a | _]} -> %{program |
        memory: a.(program, {:set, input.()}),
        pc: pointer + 2
      }
      {4, [a | _]} ->
        output.(a.(program, :get))
        %{program |
          pc: pointer + 2
        }
      inst -> Day02.execute_instruction({program, inst})
    end
  end

  def execute_instruction_b({%{memory: _, pc: pointer} = program, instruction}) do
    case instruction do
      {5, [a, b | _]} -> %{program |
        pc: (if a.(program, :get) != 0, do: b.(program, :get), else: pointer + 3)
      }
      {6, [a, b | _]} -> %{program |
        pc: (if a.(program, :get) == 0, do: b.(program, :get), else: pointer + 3)
      }
      {7, [a, b, c]} -> %{program |
        memory: c.(program, {:set, (if a.(program, :get) < b.(program, :get), do: 1, else: 0)}),
        pc: pointer + 4
      }
      {8, [a, b, c]} -> %{program |
        memory: c.(program, {:set, (if a.(program, :get) == b.(program, :get), do: 1, else: 0)}),
        pc: pointer + 4
      }
      inst -> Day05.execute_instruction_a({program, inst})
    end
  end

  def run_program(program) do
    case program do
      %{memory: _, pc: _, io: _} -> program |> decode_instruction |> execute_instruction_b |> run_program
      %{memory: memory} -> memory
    end
  end
end
