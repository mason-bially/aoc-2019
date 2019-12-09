Code.require_file("el.ex", __DIR__)

memory = Day02.read_intcode("day09/input.txt")

io = %{
  input: fn io -> {1, io} end,
  output: fn io, v ->
    IO.inspect(v) # 2671328082
    io
  end
}

Day09.run_program(%{memory: memory, pc: 0, rbase: 0, io: io})
