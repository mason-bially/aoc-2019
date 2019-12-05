defmodule Day01 do
  def module_launch_fuel(mass) do
    floor(mass / 3) - 2
  end
end

File.stream!("day01/input.txt", [encoding: :utf8], :line)
|> Stream.map(&elem(Integer.parse(&1), 0))
|> Stream.map(&Day01.module_launch_fuel(&1))
|> Enum.sum
|> IO.inspect
