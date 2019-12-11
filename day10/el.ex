Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day09/el.ex", __DIR__)

defmodule Day10 do
  def parse_space_char(tok) do
    case tok do
      "." -> false
      "#" -> true
    end
  end

  def parse_space_row(line) do
    line
    |> String.trim
    |> String.codepoints
    |> Stream.map(&parse_space_char/1)
    |> Enum.to_list
    |> :array.from_list()
  end

  def read_space(file_path) do
    File.stream!(file_path, [encoding: :utf8], :line)
    |> Stream.map(&parse_space_row/1)
    |> Enum.to_list
    |> :array.from_list()
  end

  def is_visible({w, h, space}, {ox, oy}, {px, py}) do
    if ox == px and oy == py do
      false
    else
      dx = px - ox
      dy = py - oy
      slope_scale = Integer.gcd(dx, dy)
      dx = div(dx, slope_scale)
      dy = div(dy, slope_scale)

      Stream.unfold({ox, oy}, fn {ax, ay} ->
        cond do
          ox == ax and oy == ay -> {false, {ax + dx, ay + dy}}
          ax < 0 or ax >= w or ay < 0 or ay >= h -> nil
          :array.get(ax, :array.get(ay, space)) ->
            if ax == px and ay == py do
              {true, {ax + dx, ay + dy}}
            else
              nil
            end
          true -> {false, {ax + dx, ay + dy}}
        end
      end)
      |> Enum.any?()

    end
  end

  def get_size(space) do
    w = :array.size(:array.get(0, space))
    h = :array.size(space)
    {w, h}
  end

  def count_visible(space, origin) do
    {w, h} = get_size(space)
    for px <- 0..w-1, py <- 0..h-1 do
      is_visible({w, h, space}, origin, {px, py})
    end
    |> Enum.count(fn v -> v end)
  end

  def label_laser_hit({w, h, space}, {ox, oy}, {px, py}) do
    if ox == px and oy == py do
      nil
    else
      dx = px - ox
      dy = py - oy
      slope_scale = Integer.gcd(dx, dy)
      dx = div(dx, slope_scale)
      dy = div(dy, slope_scale)

      c = Stream.unfold({0, ox, oy}, fn {c, ax, ay} ->
        cond do
          is_nil(c) -> nil
          ox == ax and oy == ay -> {false, {c, ax + dx, ay + dy}}
          ax < 0 or ax >= w or ay < 0 or ay >= h -> nil
          :array.get(ax, :array.get(ay, space)) ->
            if ax == px and ay == py do
              {c, {nil, ax + dx, ay + dy}}
            else
              {false, {c + 1, ax + dx, ay + dy}}
            end
          true -> {false, {c, ax + dx, ay + dy}}
        end
      end)
      |> Enum.at(-1)

      at = :math.atan2(dx, -dy) / :math.pi
      cond do
        is_nil(c) -> nil
        at < 0 -> {c, (at + 2) / 2}
        true -> {c, at / 2}
      end
    end
  end
end
