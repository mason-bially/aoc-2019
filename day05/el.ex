Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day02/el.ex", __DIR__)

defmodule Day05 do

  def parameter_mode_immediate(index) do
    fn
      (%{memory: memory, pc: pointer}, {:i}) -> :array.get(pointer + index, memory)
    end
  end

  def parameter_mode(mode, index) do
    case mode do
      0 -> Day02.parameter_mode_position(index)
      1 -> parameter_mode_immediate(index)
    end
  end

  def decode_opcode(%{memory: memory, pc: pointer} = program) do
    instruction = :array.get(pointer, memory)

    {
      program,
      case Integer.digits(instruction) do
        [a, b, c, d, e] -> {d * 10 + e, [parameter_mode(c, 1), parameter_mode(b, 2), parameter_mode(a, 3)]}
        [b, c, d, e] -> {d * 10 + e, [parameter_mode(c, 1), parameter_mode(b, 2), parameter_mode(0, 3)]}
        [c, d, e] -> {d * 10 + e, [parameter_mode(c, 1), parameter_mode(0, 2), parameter_mode(0, 3)]}
        [d, e] -> {d * 10 + e, [parameter_mode(0, 1), parameter_mode(0, 2), parameter_mode(0, 3)]}
        [e] -> {e, [parameter_mode(0, 1), parameter_mode(0, 2), parameter_mode(0, 3)]}
      end
    }
  end

  def execute_opcode_a({%{memory: _, pc: pointer, io: {input, output}} = program, instruction}) do
    case instruction do
      {3, [a | _]} -> %{program |
        memory: a.(program, input.()),
        pc: pointer + 2
      }
      {4, [a | _]} ->
        output.(a.(program, {:i}))
        %{program |
          pc: pointer + 2
        }
      inst -> Day02.execute_opcode({program, inst})
    end
  end

  def execute_opcode_b({%{memory: _, pc: pointer} = program, instruction}) do
    case instruction do
      {5, [a, b | _]} -> %{program |
        pc: (if a.(program, {:i}) != 0, do: b.(program, {:i}), else: pointer + 3)
      }
      {6, [a, b | _]} -> %{program |
        pc: (if a.(program, {:i}) == 0, do: b.(program, {:i}), else: pointer + 3)
      }
      {7, [a, b, c]} -> %{program |
        memory: c.(program, (if a.(program, {:i}) < b.(program, {:i}), do: 1, else: 0)),
        pc: pointer + 4
      }
      {8, [a, b, c]} -> %{program |
        memory: c.(program, (if a.(program, {:i}) == b.(program, {:i}), do: 1, else: 0)),
        pc: pointer + 4
      }
      inst -> Day05.execute_opcode_a({program, inst})
    end
  end

  def run_program(program) do
    case program do
      %{memory: _, pc: _, io: _} -> program |> decode_opcode |> execute_opcode_b |> run_program
      %{memory: memory} -> memory
    end
  end
end
