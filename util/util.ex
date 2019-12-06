defmodule Util do
  def parse_comma_while(c, acc) do
    cond do
      c == "," -> {:cont, acc, ""}
      true -> {:cont, acc <> c}
    end
  end

  def parse_after_emit(acc) do
    cond do
      acc != "" -> {:cont, acc, ""}
      true -> {:cont, ""}
    end
  end

  def stream_comma_seperated(enum) do
    Stream.chunk_while(enum, "", &parse_comma_while/2, &parse_after_emit/1)
  end
end
