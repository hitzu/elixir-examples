defmodule CashFlow.Ledger do

  defstruct payments: []

  @type t :: %__MODULE__{payments: list()}
  def new, do: %__MODULE__{payments: []}
end
