Code.require_file("el.ex", __DIR__)

init_memory = Day02.read_intcode("day02/input.txt")

try do
  for noun <- 0..99,
      verb <- 0..99 do
    memory = :array.set(1, noun, init_memory)
    memory = :array.set(2, verb, memory)

    memory = Day02.run_program(%{memory: memory, pc: 0})

    result = :array.get(0, memory)
    if result == 19690720, do: throw({noun, verb})
  end
catch
  {noun, verb} -> IO.inspect(100*noun + verb) # 3951
end
