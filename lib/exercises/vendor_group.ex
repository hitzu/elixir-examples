defmodule Exercises.VendorGroup do
  alias Exercises.ManualReducer

  @doc """
  Agrupa pagos por vendor y suma los montos.
  Recibe lista de %{vendor: "...", amount: n}
  Retorna %{"Vendor" => total}
  """
  def group_by_vendor(payments) when is_list(payments) do
    ManualReducer.reduce(payments, %{}, fn %{vendor: vendor, amount: amount}, acc ->
      Map.update(acc, vendor, amount, &(&1 + amount))
    end)
  end
end
