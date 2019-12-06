Code.require_file("../util/util.ex", __DIR__)

defmodule Day02 do
  def read_intcode(file_path) do
    File.stream!(file_path, [encoding: :utf8], 1)
    |> Util.stream_comma_seperated
    |> Stream.map(&elem(Integer.parse(&1), 0))
    |> Enum.to_list()
    |> :array.from_list()
  end

  def parameter_mode_position(index) do
    fn
      (%{memory: memory, pc: pointer}, {:i}) -> :array.get(:array.get(pointer + index, memory), memory)
      (%{memory: memory, pc: pointer}, value) -> :array.set(:array.get(pointer + index, memory), value, memory)
    end
  end

  def decode_opcode(%{memory: memory, pc: pointer} = program) do
    instruction = :array.get(pointer, memory)
    {
      program,
      {instruction, [parameter_mode_position(1), parameter_mode_position(2), parameter_mode_position(3)]}
    }
  end

  def execute_opcode({%{memory: memory, pc: pointer} = program, instruction}) do
    case instruction do
      {1, [a, b, c]} -> %{program |
        memory: c.(program, a.(program, {:i}) + b.(program, {:i})),
        pc: pointer + 4
      }
      {2, [a, b, c]} -> %{program |
        memory: c.(program, a.(program, {:i}) * b.(program, {:i})),
        pc: pointer + 4
      }
      {99, _} -> %{memory: memory}
    end
  end

  def run_program(program) do
    case program do
      %{memory: _, pc: _} -> program |> decode_opcode |> execute_opcode |> run_program
      %{memory: memory} -> memory
    end
  end
end
