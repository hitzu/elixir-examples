defmodule Exercises.PatternMaps do
  def pending([]), do: []

  def pending([%{status: :pending} = payment | rest]) do
    [payment | pending(rest)]
  end

  # Head no es pending -> lo saltamos
  def pending([_ | rest]) do
    pending(rest)
  end
end
