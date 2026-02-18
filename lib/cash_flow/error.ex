defmodule CashFlow.Error do
  defstruct [:code, :message, :field, :input]

  # define the type of the struct only for the compiler
  @type t :: %__MODULE__{
    code: atom(),
    message: String.t(),
    field: atom() | nil,
    input: any()
  }

  @spec new(atom(), String.t(), atom() | nil, any()) :: t()
  def new(code, message, field \\ nil, input) do
    %__MODULE__{code: code, message: message, field: field, input: input}
  end
end
