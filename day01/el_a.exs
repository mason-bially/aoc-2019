Code.require_file("el.ex", __DIR__)

File.stream!("day01/input.txt", [encoding: :utf8], :line)
|> Stream.map(&elem(Integer.parse(&1), 0))
|> Stream.map(&Day01.fuel_equation(&1))
|> Enum.sum
|> IO.inspect
