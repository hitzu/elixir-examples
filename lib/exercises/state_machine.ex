defmodule Exercises.StateMachine do
  @doc """
  Mini state machine usando case.
  Estados: :pending, :approved, :rejected
  Eventos: :approve, :reject, :reset
  Retorna {:ok, nuevo_estado} o {:error, :invalid_transition}
  """
  def transition(state, event) do
    case {state, event} do
      {:pending, :approve} -> {:ok, :approved}
      {:pending, :reject} -> {:ok, :rejected}
      {:approved, :reset} -> {:ok, :pending}
      {:rejected, :reset} -> {:ok, :pending}
      {_, _} -> {:error, :invalid_transition}
    end
  end
end
