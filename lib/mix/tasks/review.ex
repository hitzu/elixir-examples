defmodule Mix.Tasks.Review do
  use Mix.Task

  @shortdoc "Runs AI review on staged diff"

  def run(_args) do
    # 1) Obtener git diff staged
    # 2) Enviarlo a Claude CLI
    # 3) Mostrar resultado
  end
end
