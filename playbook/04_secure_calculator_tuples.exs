alias Exercises.SecureCalculator

IO.puts("=== SECURE CALCULATOR DEMO ===")

IO.puts("\nAdd 10 + 5:")
IO.inspect(SecureCalculator.calculate(:add, 10, 5))

IO.puts("\nSubtract 10 - 5:")
IO.inspect(SecureCalculator.calculate(:sub, 10, 5))

IO.puts("\nMultiply 10 * 5:")
IO.inspect(SecureCalculator.calculate(:mul, 10, 5))

IO.puts("\nDivide 10 / 5:")
IO.inspect(SecureCalculator.calculate(:div, 10, 5))

IO.puts("\nInvalid operation:")
IO.inspect(SecureCalculator.calculate(:invalid, 10, 5))
