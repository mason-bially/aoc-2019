Code.require_file("el.ex", __DIR__)

memory = Day02.read_intcode("day05/input.txt")

io = {
  fn -> 1 end,
  &IO.inspect(&1) # 3122865
}

Day05.run_program(%{memory: memory, pc: 0, io: io})
