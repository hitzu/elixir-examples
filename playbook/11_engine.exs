alias CashFlow.Engine

IO.puts("=== CASHFLOW ENGINE DEMO ===")

IO.puts("\n1. Crear ledger vacío:")
ledger = Engine.new_ledger()
IO.inspect(ledger)

IO.puts("\n2. Agregar pago (input limpio):")
{:ok, ledger} =
  Engine.add_payment(ledger, %{
    vendor: "CFE",
    amount: 150.50,
    direction: :out,
    status: :pending
  })
IO.inspect(ledger.payments, limit: 1)

IO.puts("\n3. Agregar pago (input sucio - string):")
{:ok, ledger} =
  Engine.add_payment(ledger, %{
    "vendor" => "AWS",
    "amount" => "$1,234.50",
    "direction" => "entra",
    "status" => "paid"
  })
IO.puts("Total pagos: #{length(ledger.payments)}")

IO.puts("\n4. Agregar pago pendiente:")
{:ok, ledger} =
  Engine.add_payment(ledger, %{
    vendor: "Telmex",
    amount: 89.00,
    direction: :out,
    status: "pendiente"
  })

IO.puts("\n5. Listar pendientes:")
IO.inspect(Engine.pending(ledger), structs: false)

IO.puts("\n6. Listar pagados:")
IO.inspect(Engine.paid(ledger), structs: false)

IO.puts("\n7. Summary:")
IO.inspect(Engine.summary(ledger))

IO.puts("\n8. Error: vendor vacío:")
IO.inspect(Engine.add_payment(ledger, %{vendor: "", amount: 100, direction: :in, status: :pending}))

IO.puts("\n9. Error: input no es map:")
IO.inspect(Engine.add_payment(ledger, "invalid"))
