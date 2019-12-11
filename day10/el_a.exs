Code.require_file("el.ex", __DIR__)

space = Day10.read_space("day10/input.txt")
{w, h} = Day10.get_size(space)

IO.puts "#{w} #{h} #{w*h}"

for px <- 0..w-1, py <- 0..h-1 do
  if :array.get(px, :array.get(py, space)) do
    {px, py, Day10.count_visible(space, {px, py})}
  else
    nil
  end
end
|> Stream.filter(fn n -> not is_nil(n) end)
|> Enum.max_by(&elem(&1, 2))
|> IO.inspect
