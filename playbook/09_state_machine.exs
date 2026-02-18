alias Exercises.StateMachine

IO.puts("=== MINI STATE MACHINE DEMO ===")

IO.puts("\n:pending + :approve ->")
IO.inspect(StateMachine.transition(:pending, :approve))

IO.puts("\n:pending + :reject ->")
IO.inspect(StateMachine.transition(:pending, :reject))

IO.puts("\n:approved + :reset ->")
IO.inspect(StateMachine.transition(:approved, :reset))

IO.puts("\n:rejected + :reset ->")
IO.inspect(StateMachine.transition(:rejected, :reset))

IO.puts("\n:approved + :approve (inválido) ->")
IO.inspect(StateMachine.transition(:approved, :approve))
