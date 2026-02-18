defmodule CashFlow.EngineTest do
  use ExUnit.Case, async: true
  alias CashFlow.Engine

  test "adds payments and summarizes cashflow" do
    ledger = Engine.new_ledger()

    {:ok, ledger} =
      Engine.add_payment(ledger, %{
        vendor: "CFE",
        amount: "$100.00",
        direction: "sale",
        status: "pending"
      })

    {:ok, ledger} =
      Engine.add_payment(ledger, %{
        "vendor" => "CLIENTE",
        "amount" => "250.50",
        "direction" => "entra",
        "status" => "paid"
      })

    assert Engine.summary(ledger) == %{in: 250.50, out: 100.00, net: 150.50}
    assert length(Engine.pending(ledger)) == 1
    assert length(Engine.paid(ledger)) == 1
  end
end
