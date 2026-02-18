defmodule CashFlow.Payment do

  @enforce_keys [:id, :vendor, :amount, :direction, :status, :inserted_at]
  defstruct [:id, :vendor, :amount, :direction, :status, :inserted_at]

  @type direction :: :in | :out
  @type status :: :pending | :paid

  @type t :: %__MODULE__{
    id: String.t(),
    vendor: String.t(),
    amount: float(),
    direction: direction(),
    status: status(),
    inserted_at: DateTime.t()
  }

  @spec new(String.t(), String.t(), float(), direction(), status(), DateTime.t()) :: t()
  def new(id, vendor, amount, direction, status, inserted_at) do
    %__MODULE__{
      id: id,
      vendor: vendor,
      amount: amount,
      direction: direction,
      status: status,
      inserted_at: inserted_at
    }
  end
end
