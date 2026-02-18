defmodule Exercises.ValidationWith do
  @doc """
  Valida vendor no vacío, monto > 0, direction válida.
  {:ok, :valid} si todo ok, o propaga error con with.
  """
  @valid_directions [:in, :out]

  def validate(%{vendor: vendor, amount: amount, direction: direction}) do
    with {:ok, _} <- validate_vendor(vendor),
         {:ok, _} <- validate_amount(amount),
         {:ok, _} <- validate_direction(direction) do
      {:ok, :valid}
    end
  end

  defp validate_vendor(vendor) when is_binary(vendor) and byte_size(vendor) > 0 do
    {:ok, vendor}
  end

  defp validate_vendor(_), do: {:error, :vendor_empty}

  defp validate_amount(amount) when is_number(amount) and amount > 0 do
    {:ok, amount}
  end

  defp validate_amount(_), do: {:error, :amount_invalid}

  defp validate_direction(direction) when direction in @valid_directions do
    {:ok, direction}
  end

  defp validate_direction(_), do: {:error, :invalid_direction}
end
