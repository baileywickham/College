defmodule SerializeTest do
  use ExUnit.Case

  test "Serialize values" do
    assert Serialize.serialize(3) == "3"
    assert Serialize.serialize("hello") == "\"hello\""
    assert Serialize.serialize(true) == "true"
    assert Serialize.serialize(TopEnv.top_env()[:+]) == "#<primop>"
    assert Serialize.serialize(%ClosV{args: [], body: 3, env: []}) == "#<procedure>"
  end
end
