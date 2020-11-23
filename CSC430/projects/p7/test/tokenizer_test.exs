defmodule TokenizerTest do
  use ExUnit.Case

  test "Tokenizes literals" do
    assert Tokenize.tokenize("\"hello\"") == "hello"
    assert Tokenize.tokenize("8") == 8
    assert Tokenize.tokenize("-1") == -1
    assert Tokenize.tokenize("{\"hello\"}") == ["hello"]
  end
end
