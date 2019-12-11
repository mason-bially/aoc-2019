Code.require_file("el.ex", __DIR__)

end_state = Day09.run_program(%{
  memory: Day02.read_intcode("day11/input.txt"),
  io: Day11.hull_robot_io(%{})
})

IO.inspect(map_size(end_state.io.panels))
