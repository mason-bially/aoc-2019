Code.require_file("el.ex", __DIR__)

memory = Day02.read_intcode("day09/input.txt")

io = %{
  input: fn io -> {2, io} end,
  output: fn io, v ->
    IO.inspect(v) # 59095
    io
  end
}

Day09.run_program(%{memory: memory, io: io})
