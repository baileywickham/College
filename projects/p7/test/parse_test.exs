defmodule ParserTests do
  use ExUnit.Case

  test "Parses literals" do
    assert Parse.parse(3) == 3
    assert Parse.parse("hello") == "hello"
    assert Parse.parse(:id) == :id
  end

  test "Parses more complex expressions" do
    assert Parse.parse([:if, "this", 5, :that]) ==
             %IfC{f: "this", t: 5, e: :that}

    assert Parse.parse([:fn, [:a, :b], [:+, 1, 2]]) ==
             %LamC{
               args: [:a, :b],
               body: %AppC{
                 f: :+,
                 args: [1, 2]
               }
             }

    assert Parse.parse([[:fn, [], 1]]) ==
             %AppC{
               f: %LamC{
                 args: [],
                 body: 1
               },
               args: []
             }
  end

  test "De-sugars let expressions" do
    assert Parse.parse([:let, [:a, :=, 1], :in, [:+, 3, :a]]) ==
             %AppC{
               f: %LamC{
                 args: [:a],
                 body: %AppC{
                   f: :+,
                   args: [3, :a]
                 }
               },
               args: [1]
             }
  end

  test "Reject malformed expressions" do
    assert_raise DxuqError, fn -> Parse.parse([]) end
    assert_raise DxuqError, fn -> Parse.parse([:fn, :a, "body"]) end
    assert_raise DxuqError, fn -> Parse.parse([:fn, :b, "body", :extra]) end
    assert_raise DxuqError, fn -> Parse.parse([:if, :c, "then"]) end
    assert_raise DxuqError, fn -> Parse.parse([:let, [:a, :=, 1], [:+, 3, :a]]) end
    assert_raise DxuqError, fn -> Parse.parse([:let, [:a, 1], [:+, 3, :a]]) end
  end
end
