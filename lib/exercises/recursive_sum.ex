defmodule Exercises.RecursiveSum do
  def sum(list) when is_list(list) and length(list) > 0 do
    [head | tail] = list
    {:ok, rest_sum} = sum(tail)
    result = head + rest_sum
    {:ok, result}
  end

  def sum(list) when is_list(list) and length(list) == 0 do
    {:ok, 0}
  end

  def sum(_other) do
    {:error, :invalid_input}
  end
end
