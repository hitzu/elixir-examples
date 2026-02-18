defmodule Exercises.PatternsAtoms do
  def process(:direction, :in) do
    {:ok, :in}
  end

  def process(:direction, "entra") do
    {:ok, :in}
  end

  def process(:direction, :out) do
    {:ok, :out}
  end

  def process(:direction, "sale") do
    {:ok, :out}
  end

  def process(:direction, other) do
    {:error, "Unknown direction: #{inspect(other)}"}
  end
end
