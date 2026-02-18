defmodule Exercises.NumberClassificator do
  def classify(number) when number > 0 do
    {:ok, :positive}
  end

  def classify(number) when number < 0 do
    {:ok, :negative}
  end

  def classify(number) when number == 0 do
    {:ok, :zero}
  end

  def classify(other) do
    {:error, "Unknown number: #{inspect(other)}"}
  end
end
