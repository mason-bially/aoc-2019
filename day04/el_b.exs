Code.require_file("el.ex", __DIR__)

defmodule Day04.B do
  def label_digits(digits) do
    digits
    |> Enum.with_index
    |> Enum.map(fn {elem, idx} ->
      with left <- (if idx == 0, do: nil, else: Enum.at(digits, idx - 1)),
        right <- Enum.at(digits, idx + 1) do
        cond do
          left == right -> :both
          left == elem -> :left
          right == elem -> :right
          true -> nil
        end
      end
    end)
  end

  def valid_password(x) do
    Day04.A.valid_password(x)
      and Integer.digits(x)
        |> label_digits
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.any?(fn [a, b] -> a == :right and b == :left end)
  end
end

IO.inspect(Day04.count_password_possibilities(&Day04.B.valid_password/1, Day04.input_begin, 0))
