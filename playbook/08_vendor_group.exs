alias Exercises.VendorGroup

IO.puts("=== VENDOR GROUP DEMO ===")

payments = [
  %{vendor: "CFE", amount: 100},
  %{vendor: "CFE", amount: 200},
  %{vendor: "AWS", amount: 50}
]

IO.puts("\nLista de pagos:")
IO.inspect(payments)

IO.puts("\nAgrupado por vendor (suma de montos):")
IO.inspect(VendorGroup.group_by_vendor(payments))

IO.puts("\nLista vacía:")
IO.inspect(VendorGroup.group_by_vendor([]))
