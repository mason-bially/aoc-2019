Code.require_file("el.ex", __DIR__)

space = Day10.read_space("day10/input.txt")
{w, h} = Day10.get_size(space)

IO.puts "#{w} #{h} #{w*h}"

{x, y, c} =
  for px <- 0..w-1, py <- 0..h-1 do
    if :array.get(px, :array.get(py, space)) do
      {px, py, Day10.count_visible(space, {px, py})}
    else
      nil
    end
  end
  |> Stream.filter(fn n -> not is_nil(n) end)
  |> Enum.max_by(&elem(&1, 2))

IO.puts "#{x} #{y} #{c}"

for px <- 0..w-1, py <- 0..h-1 do
  if :array.get(px, :array.get(py, space)) do
    {px, py, Day10.label_laser_hit({w, h, space}, {x, y}, {px, py})}
  else
    nil
  end
end
|> Stream.filter(fn n -> not is_nil(n) and not is_nil(elem(n, 2)) end)
|> Stream.map(fn {x, y, {c, at}} -> {x, y, c + at} end)
|> Enum.sort_by(&elem(&1, 2))
|> Enum.at(199)
|> IO.inspect
#|> Enum.each(fn a -> IO.puts("#{inspect a}") end)
