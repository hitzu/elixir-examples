alias Exercises.PatternsAtoms

IO.puts("=== PATTERN MATCHING ATOMS DEMO ===")

IO.puts("\nDirection in:")
IO.inspect(PatternsAtoms.process(:direction, :in))
IO.inspect(PatternsAtoms.process(:direction, "entra"))

IO.puts("\nDirection out:")
IO.inspect(PatternsAtoms.process(:direction, :out))
IO.inspect(PatternsAtoms.process(:direction, "sale"))

IO.puts("\nDirection unknown:")
IO.inspect(PatternsAtoms.process(:direction, :unknown))
