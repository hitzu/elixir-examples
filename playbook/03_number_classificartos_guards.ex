alias Exercises.NumberClassificator

IO.puts("=== NUMBER CLASSIFICATOR DEMO ===")

IO.puts("\nPositive number:")
IO.inspect(NumberClassificator.classify(10))

IO.puts("\nNegative number:")
IO.inspect(NumberClassificator.classify(-10))

IO.puts("\nZero:")
IO.inspect(NumberClassificator.classify(0))

IO.puts("\nUnknown number:")
