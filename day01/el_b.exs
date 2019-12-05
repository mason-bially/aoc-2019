Code.require_file("el.ex", __DIR__)

File.stream!("day01/input.txt", [encoding: :utf8], :line)
|> Stream.map(&elem(Integer.parse(&1), 0))
|> Stream.map(
  &Enum.sum(
    Stream.unfold(Day01.fuel_equation(&1), fn
      x when x <= 0 -> nil
      x -> {x, Day01.fuel_equation(x)}
    end)))
|> Enum.sum()
|> IO.inspect
