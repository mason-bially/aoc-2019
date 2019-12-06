Code.require_file("../util/util.ex", __DIR__)

defmodule Day06 do
  def parse_orbit(tok) do
    [a, b] = String.split(String.trim(tok), ")")
    {a, b}
  end

  defmodule Object do
    defstruct orbits: nil, orbiters: MapSet.new(), depth: 0
  end

  def insert_orbit(%{} = map, {orbitee, orbiter}) do
    {_, map} = Map.get_and_update(map, orbitee,
      fn v ->
        with obj <- (v || %Object{}) do
          {v, %{obj | orbiters: MapSet.put(obj.orbiters, orbiter)}}
        end
      end)
    {_, map} = Map.get_and_update(map, orbiter,
      fn v ->
        {v, %{v || %Object{} | orbits: orbitee}}
      end)
    map
  end

  def objects_set_orbit_depth(map, object \\ "COM", depth \\ 0)
  def objects_set_orbit_depth(%{} = map, object, depth) do
    {%{orbiters: orbiters}, map} =
      Map.get_and_update!(map, object,
        fn value -> {value, %{value | depth: depth}} end)
    Enum.reduce(orbiters, map, &objects_set_orbit_depth(&2, &1, depth + 1))
  end

  def orbit_list(%{} = map, thing, com \\ "COM") do
    Stream.unfold(thing, fn
      nil -> nil
      orbit when orbit == com -> {orbit, nil}
      orbit -> {orbit, Map.fetch!(map, orbit).orbits}
    end)
    |> Enum.to_list
  end
end
