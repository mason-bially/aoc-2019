Code.require_file("el.ex", __DIR__)

defmodule Day04.A do
  def valid_password(x) do
    digits = Integer.digits(x)
    pairs = Enum.chunk_every(digits, 2, 1, :discard)
    Enum.all?(pairs, fn ([a, b]) -> a <= b end) and Enum.any?(pairs, fn ([a, b]) -> a == b end)
  end

  def count_password_possibilities(value, count) do
    if value <= Day04.input_end do
      count_password_possibilities(value + 1, count + (if valid_password(value), do: 1, else: 0))
    else
      count
    end
  end
end

IO.inspect(Day04.A.count_password_possibilities(Day04.input_begin, 0))
