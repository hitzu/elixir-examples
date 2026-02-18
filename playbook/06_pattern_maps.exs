alias Exercises.PatternMaps

IO.puts("=== PENDING PAYMENTS (pattern matching) ===")

payments = [
  %{status: :paid},
  %{status: :pending},
  %{status: :pending},
  %{status: :paid}
]

IO.puts("\nLista completa:")
IO.inspect(payments)

IO.puts("\nSolo pendientes:")
IO.inspect(PatternMaps.pending(payments))

IO.puts("\nLista vacía:")
IO.inspect(PatternMaps.pending([]))
