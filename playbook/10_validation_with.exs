alias Exercises.ValidationWith

IO.puts("=== VALIDATION WITH DEMO ===")

IO.puts("\nValidación OK (vendor, amount > 0, direction válida):")
IO.inspect(ValidationWith.validate(%{vendor: "CFE", amount: 100, direction: :in}))

IO.puts("\nVendor vacío:")
IO.inspect(ValidationWith.validate(%{vendor: "", amount: 100, direction: :in}))

IO.puts("\nMonto <= 0:")
IO.inspect(ValidationWith.validate(%{vendor: "CFE", amount: 0, direction: :in}))

IO.puts("\nDirection inválida:")
IO.inspect(ValidationWith.validate(%{vendor: "CFE", amount: 100, direction: :invalid}))
