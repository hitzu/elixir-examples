defmodule Exercises.SecureCalculator do
  def calculate(operation, a, b) when operation in [:add, :sub, :mul, :div] do
    case operation do
      :add -> {:ok, a + b}
      :sub -> {:ok, a - b}
      :mul -> {:ok, a * b}
      :div -> {:ok, a / b}
    end
  end

  def calculate(_operation, _a, _b) do
    {:error, :invalid_operation}
  end
end
