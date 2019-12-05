Code.require_file("../util/util.ex", __DIR__)

defmodule Day02 do
  def intcode_splitter(c, acc) do
    cond do
      c == "," and acc != "" -> {:cont, acc, ""}
      c >= "0" or c <= "9" -> {:cont, acc <> c}
      true -> {:cont, ""}
    end
  end

  def read_intcode(file_path) do
    File.stream!(file_path, [encoding: :utf8], 1)
    |> Stream.chunk_while("", &intcode_splitter/2, fn acc -> {:cont, acc, ""} end)
    |> Stream.map(&elem(Integer.parse(&1), 0))
    |> Enum.to_list()
    |> :array.from_list()
  end

  def opcode_1({memory, pointer} = _program) do
    read_a = :array.get(pointer + 1, memory)
    read_b = :array.get(pointer + 2, memory)
    dest_c = :array.get(pointer + 3, memory)

    a = :array.get(read_a, memory)
    b = :array.get(read_b, memory)
    c = a + b
    memory = :array.set(dest_c, c, memory)

    {memory, pointer + 4}
  end

  def opcode_2({memory, pointer} = _program) do
    read_a = :array.get(pointer + 1, memory)
    read_b = :array.get(pointer + 2, memory)
    dest_c = :array.get(pointer + 3, memory)

    a = :array.get(read_a, memory)
    b = :array.get(read_b, memory)
    c = a * b
    memory = :array.set(dest_c, c, memory)

    {memory, pointer + 4}
  end

  def execute_opcode({memory, pointer} = program) do
    case :array.get(pointer, memory) do
      1 -> opcode_1(program)
      2 -> opcode_2(program)
      99 -> {memory}
    end
  end

  def run_program(program) do
    case program do
      {_memory, _pointer} -> run_program(execute_opcode(program))
      {memory} -> memory
    end
  end
end
