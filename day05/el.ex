Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day02/el.ex", __DIR__)

defmodule Day05 do
  def parameter_mode_immediate(index) do
    fn
      (%{memory: memory, pc: pointer}, :get) -> :array.get(pointer + index, memory)
    end
  end

  def fetch_instruction(%{memory: memory, pc: pointer} = program) do
    {program, :array.get(pointer, memory)}
  end

  def decode_instruction_length(opcode) do
    cond do
      opcode in [1, 2, 7, 8] -> 4
      opcode in [5, 6] -> 3
      opcode in [3, 4] -> 2
      opcode in [99] -> 1
    end
  end

  def decode_opcode({%{} = program, instruction}, decode_instruction_length) do
    opcode = rem(instruction, 100)

    {program, {instruction, opcode, decode_instruction_length.(opcode)} }
  end

  def decode_parameter_mode(mode, index) do
    case mode do
      0 -> Day02.parameter_mode_position(index)
      1 -> parameter_mode_immediate(index)
    end
  end

  def decode_instruction_parameters(params_count, mode, parameter_mode) do
    Integer.digits(mode)
    |> Enum.reverse
    |> Stream.concat(Stream.repeatedly(fn -> 0 end))
    |> Enum.zip(1..params_count)
    |> Enum.map(fn {mode, index} -> parameter_mode.(mode, index) end)
  end

  def decode_parameters({%{} = program, {instruction, opcode, opcode_length}}, parameter_mode) do
    mode = div(instruction, 100)

    {program, {opcode, decode_instruction_parameters(opcode_length-1, mode, parameter_mode)}}
  end

  def execute_instruction_a({%{memory: _, pc: pointer, io: %{input: input, output: output} = io} = program, instruction}) do
    case instruction do
      {3, [a | _]} ->
        {invalue, newio} = input.(io)
        %{program |
          memory: a.(program, {:set, invalue}),
          io: newio,
          pc: pointer + 2
        }
      {4, [a | _]} ->
        %{program |
          io: output.(io, a.(program, :get)),
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
      %{pc: nil} -> program
      %{memory: _, pc: _, io: _} ->
        program
        |> fetch_instruction
        |> decode_opcode(&decode_instruction_length/1)
        |> decode_parameters(&decode_parameter_mode/2)
        |> execute_instruction_b
        |> run_program
    end
  end
end
