Code.require_file("../util/util.ex", __DIR__)

defmodule Day01 do
  def fuel_equation(mass) do
    floor(mass / 3) - 2
  end
end
