Code.require_file("el.ex", __DIR__)

memory = Day02.read_intcode("day05/input.txt")

io = %{
  input: fn io -> {5, io} end,
  output: fn io, v ->
    IO.inspect(v) # 773660
    io
  end
}

Day05.run_program(%{memory: memory, pc: 0, io: io})

