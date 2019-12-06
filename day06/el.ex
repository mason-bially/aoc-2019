Code.require_file("../util/util.ex", __DIR__)

defmodule Day06 do
  def parse_orbit(tok) do
    [a, b] = String.split(String.trim(tok), ")")
    {a, b}
  end

  def update_object_orbiter({orbiters, orbit_count}, new_orbiter) do
    orbiters = MapSet.put(orbiters, new_orbiter)

    {orbiters, orbit_count}
  end

  def insert_orbit(%{} = map, {orbitee, orbiter}) do
    object = Map.get(map, orbitee, {MapSet.new(), 0})
    object = update_object_orbiter(object, orbiter)
    map = Map.put(map, orbitee, object)
    map = Map.put_new(map, orbiter, {MapSet.new(), 0})
    map
  end

  def objects_set_orbit_count(map, object \\ "COM", count \\ 0)
  def objects_set_orbit_count(%{} = map, object, count) do
    {orbiters, _} = Map.get(map, object)
    map = Map.put(map, object, {orbiters, count})

    Enum.reduce(orbiters, map, &objects_set_orbit_count(&2, &1, count + 1))
  end
end
