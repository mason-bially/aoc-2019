Code.require_file("el.ex", __DIR__)

memory = Day02.read_intcode("day02/input.txt")
memory = :array.set(1, 12, memory)
memory = :array.set(2, 2, memory)

memory = Day02.run_program({memory, 0})

result = :array.get(0, memory)
IO.inspect(result) # 6568671
