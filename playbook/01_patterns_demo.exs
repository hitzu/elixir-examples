alias Exercises.Patterns

IO.puts("=== PATTERN MATCHING DEMO ===")

IO.puts("\nRectangle 4x5:")
IO.inspect(Patterns.area({:rectangle, 4, 5}))

IO.puts("\nCircle r=3:")
IO.inspect(Patterns.area({:circle, 3}))

IO.puts("\nSquare a=6:")
IO.inspect(Patterns.area({:square, 6}))

IO.puts("\nUnknown shape:")
IO.inspect(Patterns.area({:triangle, 3, 4, 5}))
