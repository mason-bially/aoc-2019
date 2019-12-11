Code.require_file("../util/util.ex", __DIR__)
Code.require_file("../day09/el.ex", __DIR__)

defmodule Day11 do

  def apply_rotate(angle, 0) do
    case angle do
      {0, 1} -> {-1, 0}
      {-1, 0} -> {0, -1}
      {0, -1} -> {1, 0}
      {1, 0} -> {0, 1}
    end
  end
  def apply_rotate(angle, 1) do
    case angle do
      {0, 1} -> {1, 0}
      {1, 0} -> {0, -1}
      {0, -1} -> {-1, 0}
      {-1, 0} -> {0, 1}
    end
  end

  def hull_robot_io(init_panels) do
    %{
      panels: init_panels,
      location: {0, 0},
      angle: {0, 1},
      painted: false,
      input: fn
        %{panels: panels, location: location} = io ->
          {Map.get(panels, location, 0), io}
      end,
      output: fn
        %{panels: panels, location: location, painted: false} = io, value ->
          %{io | panels: Map.put(panels, location, value), painted: true}
        %{angle: angle, location: {x, y}, painted: true} = io, value ->
          {ax, ay} = apply_rotate(angle, value)
          %{io | angle: {ax, ay}, location: {x + ax, y + ay}, painted: false}
      end
    }
  end
end
