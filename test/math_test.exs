defmodule Playground.MathTest do
  use ExUnit.Case
  alias Playground.Math

  test "adds two numbers" do
    assert Math.add(2, 3) == 5
  end
end
