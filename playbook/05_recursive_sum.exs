alias Exercises.RecursiveSum

IO.puts("=== RECURSIVE SUM DEMO ===")

IO.puts("\nSum of [1, 2, 3, 4, 5]:")
IO.inspect(RecursiveSum.sum([1, 2, 3, 4, 5]))

IO.puts("\nSum of []:")
IO.inspect(RecursiveSum.sum([]))

IO.puts("\nSum of [1]:")
IO.inspect(RecursiveSum.sum([1]))

IO.puts("\nSum of 1:")
IO.inspect(RecursiveSum.sum(1))
