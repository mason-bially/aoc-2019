Code.require_file("el.ex", __DIR__)

defmodule Day04.B do
  def valid_password(x) do
    digits = Integer.digits(x)
    pairs = Enum.chunk_every(digits, 2, 1, :discard)
    triples = Enum.chunk_every(digits, 3, 1, :discard)
    Enum.all?(pairs, fn ([a, b]) -> a <= b end)
      and Enum.count(pairs, fn ([a, b]) -> a == b end) != Enum.count(triples, fn ([a, b, c]) -> a == b and b == c end)
  end

  def count_password_possibilities(value, count) do
    if value <= Day04.input_end do
      count_password_possibilities(value + 1, count + (if valid_password(value), do: 1, else: 0))
    else
      count
    end
  end
end

#IO.inspect(Day04.B.count_password_possibilities(Day04.input_begin, 0))

IO.inspect(Day04.B.valid_password(123444))
IO.inspect(Day04.B.valid_password(111122))
