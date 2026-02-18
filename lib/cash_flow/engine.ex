defmodule CashFlow.Engine do
  alias CashFlow.{Ledger, Payment, Parser, Error}

  @spec new_ledger() :: Ledger.t()
  def new_ledger, do: Ledger.new()

  @spec add_payment(Ledger.t(), map()) :: {:ok, Ledger.t()} | {:error, Error.t()}
  def add_payment(%Ledger{} = ledger, raw) when is_map(raw) do
    with {:ok, vendor} <- parse_vendor(raw),
         {:ok, amount} <- Parser.parse_amount(get(raw, :amount)),
         {:ok, direction} <- Parser.parse_direction(get(raw, :direction)),
         {:ok, status} <- Parser.parse_status(get(raw, :status)) do
      payment = %Payment{
        id: generate_id(),
        vendor: vendor,
        amount: amount,
        direction: direction,
        status: status,
        inserted_at: DateTime.utc_now()
      }

      {:ok, %{ledger | payments: [payment | ledger.payments]}}
    end
  end

  def add_payment(_ledger, raw) do
    {:error, Error.new(:invalid_input, "payment input must be a map", nil, raw)}
  end

  @spec pending(Ledger.t()) :: [Payment.t()]
  def pending(%Ledger{} = ledger), do: Enum.filter(ledger.payments, &(&1.status == :pending))

  @spec paid(Ledger.t()) :: [Payment.t()]
  def paid(%Ledger{} = ledger), do: Enum.filter(ledger.payments, &(&1.status == :paid))

  @spec summary(Ledger.t()) :: %{in: float(), out: float(), net: float()}
  def summary(%Ledger{} = ledger) do
    {in_cents, out_cents} =
      Enum.reduce(ledger.payments, {0, 0}, fn p, {acc_in, acc_out} ->
        case p.direction do
          :in -> {acc_in + p.amount, acc_out}
          :out -> {acc_in, acc_out + p.amount}
        end
      end)

    %{in: in_cents, out: out_cents, net: in_cents - out_cents}
  end


   # --- helpers ---
  defp parse_vendor(raw) do
    vendor = get(raw, :vendor)

    cond do
      is_binary(vendor) and String.trim(vendor) != "" -> {:ok, String.trim(vendor)}
      true -> {:error, Error.new(:invalid_vendor, "vendor is required", :vendor, vendor)}
    end
  end

  defp get(map, key) do
    Map.get(map, key) || Map.get(map, Atom.to_string(key))
  end

  defp generate_id do
    :crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)
  end
end
