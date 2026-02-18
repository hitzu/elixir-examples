defmodule Exercises.ManualReducer do
  @doc """
  Implementa reduce manual (simula Enum.reduce).
  reduce(list, acc, fun) donde fun es fn elemento, acumulador -> nuevo_acumulador end
  """
  def reduce([], acc, _fun), do: acc

  def reduce([head | tail], acc, fun) do
    new_acc = fun.(head, acc)
    reduce(tail, new_acc, fun)
  end
end
