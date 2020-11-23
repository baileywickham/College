defmodule InterpTest do
  use ExUnit.Case

  test "Interp literals" do
    assert Interp.interp(3, %{}) == 3
    assert Interp.interp("hello", %{}) == "hello"
    assert Interp.interp(:id, %{:id => 5}) == 5
  end

  test "Interp functions" do
    assert Interp.interp(%AppC{f: :+, args: [3, 4]}, TopEnv.top_env()) == 7
  end
end
