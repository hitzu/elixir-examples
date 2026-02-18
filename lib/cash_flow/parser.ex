defmodule CashFlow.Parser do
  @moduledoc """
  This module is responsible for parsing the amount of a payment.
  It supports integers, floats, and strings.
  It returns an error if the amount is not a valid integer or float.
  output: {ok: float(amount.cents), error: Error.t()}
  """
  alias CashFlow.Error

   @spec parse_amount(any()) :: {:ok, float()} | {:error, Error.t()}
   def parse_amount(amount) when is_integer(amount) do
    if amount >= 0 do
      {:ok, Float.round(amount * 1.0, 2)}
    else
      {:error, Error.new(:invalid_amount, "Amount must be greater than 0", :amount, amount)}
    end
   end

   def parse_amount(amount) when is_float(amount) do
    if amount >= 0 do
      {:ok, Float.round(amount, 2)}
    else
      {:error, Error.new(:invalid_amount, "Amount must be greater than 0", :amount, amount)}
    end
   end

   def parse_amount(amount) when is_binary(amount) do
    cleaned = amount |> String.trim() |> String.replace(~r/[\$#,\s]/u, "")

    case cleaned do
      "" -> {:error, Error.new(:invalid_amount, "Amount must be a valid number", :amount, amount)}
      _ ->
        case Float.parse(cleaned) do
          {float, ""} -> {:ok, Float.round(float, 2)}
          _ -> {:error, Error.new(:invalid_amount, "Amount must be a valid number", :amount, amount)}
        end
    end
   end

   def pase_amount(other) do
    {:error, Error.new(:invalid_amount, "Amount must be a valid number", :amount, other)}
   end

   def parse_direction(:in), do: {:ok, :in}
   def parse_direction(:out), do: {:ok, :out}

   def parse_direction(dir) when is_binary(dir) do
    normalized = dir |> String.trim() |> String.downcase()

    cond do
      normalized in ["entra", "in", "entrada", "ingreso", "income"] -> {:ok, :in}
      normalized in ["sale", "out", "salida", "egreso", "expense"] -> {:ok, :out}
      true -> {:error, Error.new(:invalid_direction, "direction is invalid", :direction, dir)}
    end
  end

  def parse_direction(other),
    do: {:error, Error.new(:invalid_direction, "direction type is invalid", :direction, other)}

  def parse_status(:pending), do: {:ok, :pending}
  def parse_status(:paid), do: {:ok, :paid}

  def parse_status(status) when is_binary(status) do
    normalized = status |> String.trim() |> String.downcase()

    cond do
      normalized in ["pending", "pendiente"] -> {:ok, :pending}
      normalized in ["paid", "pagado", "realizado"] -> {:ok, :paid}
      true -> {:error, Error.new(:invalid_status, "status is invalid", :status, status)}
    end
  end

  def parse_status(other),
    do: {:error, Error.new(:invalid_status, "status type is invalid", :status, other)}

end
