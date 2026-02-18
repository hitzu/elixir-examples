defmodule CashFlow.ParserTest do
  use ExUnit.Case, async: true
  alias CashFlow.Parser

  test "parse_amount handles integer pesos" do
    assert {:ok, 123.0} = Parser.parse_amount(123)
  end

  test "parse_amount handles float pesos" do
    assert {:ok, 123.45} = Parser.parse_amount(123.45)
  end

  test "parse_amount handles strings with symbols" do
    assert {:ok, 123.30} = Parser.parse_amount("$123.30")
    assert {:ok, 1234.50} = Parser.parse_amount(" #1,234.50 ")
  end

  test "parse_amount rejects invalid" do
    assert {:error, _} = Parser.parse_amount("abc")
    assert {:error, _} = Parser.parse_amount(-1)
  end
end
