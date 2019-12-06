Code.require_file("../util/util.ex", __DIR__)

defmodule Day03 do
  def parse_pathdir(tok) do
    {dir, num} = String.split_at(tok, 1)

    {String.to_existing_atom(dir), Integer.parse(num) |> elem(0)}
  end

  def parse_path(line) do
    line
    |> String.codepoints
    |> Util.stream_comma_seperated
    |> Stream.map(&parse_pathdir/1)
    |> Enum.to_list
  end

  def read_paths(file_path) do
    File.stream!(file_path, [encoding: :utf8], :line)
    |> Stream.map(&parse_path/1)
    |> Enum.to_list
  end

  def next_coordinate({x, y}, instruction) do
    case instruction do
      {:U, up} -> {x, y + up}
      {:D, down} -> {x, y - down}
      {:R, right} -> {x + right, y}
      {:L, left} -> {x - left, y}
    end
  end

  def path_to_coords(path, coord \\ {0, 0})
  def path_to_coords([], coord), do: [coord]
  def path_to_coords([head | path], coord) do
      [coord] ++ path_to_coords(path, next_coordinate(coord, head))
  end

  def next_coordinate_dist({x, y, dist}, instruction) do
    case instruction do
      {:U, up} -> {x, y + up, dist + up}
      {:D, down} -> {x, y - down, dist + down}
      {:R, right} -> {x + right, y, dist + right}
      {:L, left} -> {x - left, y, dist + left}
    end
  end

  def path_to_coords_dist(path, coord \\ {0, 0, 0})
  def path_to_coords_dist([], coord), do: [coord]
  def path_to_coords_dist([head | path], coord) do
      [coord] ++ path_to_coords_dist(path, next_coordinate_dist(coord, head))
  end

  def coords_to_segments(coords) do
    Stream.chunk_every(coords, 2, 1, :discard)
  end

  def intersect_segments([{a0x, a0y}, {a1x, a1y}] = _seg_a, [{b0x, b0y}, {b1x, b1y}] = _seg_b) do
    ax_straight = a0x == a1x
    bx_straight = b0x == b1x
    cond do
      # Early discard parrallel
      ax_straight == bx_straight
        -> nil
      # seg a is horizontal, seg b is vertical
      # * test both seg b x against constant seg a x
      # * test both seg a y against constant seg b y
      ax_straight
        and ((b0x <= a0x) != (b1x <= a0x))
        and ((a0y <= b0y) != (a1y <= b0y))
        -> {a0x, b0y}
      # seg a is vertical, seg b is horizontal
      # * test both seg a x against constant seg b x
      # * test both seg b y against constant seg a y
      bx_straight
        and ((a0x <= b0x) != (a1x <= b0x))
        and ((b0y <= a0y) != (b1y <= a0y))
        -> {b0x, a0y}
      # No intersect
      true -> nil
    end
  end

  def intersect_segments([{a0x, a0y, a0d}, {a1x, a1y, a1d}] = _seg_a, [{b0x, b0y, b0d}, {b1x, b1y, b1d}] = _seg_b) do
    p = intersect_segments([{a0x, a0y}, {a1x, a1y}], [{b0x, b0y}, {b1x, b1y}])

    unless is_nil(p) do
      {rx, ry} = p

      {adp, ad} = if a0d < a1d, do: {{a0x, a0y}, a0d}, else: {{a1x, a1y}, a1d}
      {bdp, bd} = if b0d < b1d, do: {{b0x, b0y}, b0d}, else: {{b1x, b1y}, b1d}

      {rx, ry, ad + bd + Util.manhatten_distance(p, adp) + Util.manhatten_distance(p, bdp)}
    end
  end
end
