Code.require_file("../util/util.ex", __DIR__)

defmodule Day04 do
  def input_begin, do: 130254
  def input_end, do: 678285

  def count_password_possibilities(validator, value, count) do
    if value <= Day04.input_end do
      count_password_possibilities(validator, value + 1, count + (if validator.(value), do: 1, else: 0))
    else
      count
    end
  end
end

defmodule Day04.A do
  def valid_password(x) do
    digits = Integer.digits(x)
    pairs = Enum.chunk_every(digits, 2, 1, :discard)
    Enum.all?(pairs, fn ([a, b]) -> a <= b end) and Enum.any?(pairs, fn ([a, b]) -> a == b end)
  end
end
