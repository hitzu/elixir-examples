defmodule Exercises.Patterns do
  def area({:rectangle, a, b}) do
    a * b
  end

  def area({:circle, r}) do
    :math.pi() * r * r
  end

  def area({:square, a}) do
    a * a
  end

  def area(other) do
    {:error, "Unknown shape: #{inspect(other)}"}
  end
end
