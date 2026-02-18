alias Exercises.ManualReducer

IO.puts("=== MANUAL REDUCER DEMO ===")

IO.puts("\nreduce([1, 2, 3], 0, fn x, acc -> x + acc end):")
IO.inspect(ManualReducer.reduce([1, 2, 3], 0, fn x, acc -> x + acc end))

IO.puts("\nreduce([1, 2, 3], 1, fn x, acc -> x * acc end):")
IO.inspect(ManualReducer.reduce([1, 2, 3], 1, fn x, acc -> x * acc end))

IO.puts("\nreduce([], 0, fn x, acc -> x + acc end):")
IO.inspect(ManualReducer.reduce([], 0, fn x, acc -> x + acc end))
