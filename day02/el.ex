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
      (%{memory: memory, pc: pointer}, :get) ->
        :array.get(:array.get(pointer + index, memory), memory)
      (%{memory: memory, pc: pointer}, {:set, value}) ->
        :array.set(:array.get(pointer + index, memory), value, memory)
    end
  end

  def decode_instruction(%{memory: memory, pc: pointer} = program) do
    instruction = :array.get(pointer, memory)
    {
      program,
      {instruction, [parameter_mode_position(1), parameter_mode_position(2), parameter_mode_position(3)]}
    }
  end

  def execute_instruction({%{memory: _, pc: pointer} = program, instruction}) do
    case instruction do
      {1, [a, b, c]} -> %{program |
        memory: c.(program, {:set, a.(program, :get) + b.(program, :get)}),
        pc: pointer + 4
      }
      {2, [a, b, c]} -> %{program |
        memory: c.(program, {:set, a.(program, :get) * b.(program, :get)}),
        pc: pointer + 4
      }
      {99, _} -> %{program | pc: nil}
    end
  end

  def run_program(program) do
    case program do
      %{memory: memory, pc: nil} -> memory
      %{memory: _, pc: _} -> program |> decode_instruction |> execute_instruction |> run_program
    end
  end
end
