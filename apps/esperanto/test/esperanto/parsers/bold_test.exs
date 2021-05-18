defmodule Esperanto.Parsers.BoldTest do
  alias Esperanto.Parsers.Bold
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  use ExUnit.Case

  describe "should_parse/4" do
    test "when input matches the regex, Then should_parse has to return true" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "**"}

      assert true == Bold.should_parse(walker, tree, tree.root, [])
    end

    test "when input does not matches the regex, Then should_parse has to return false" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "*1"}

      assert false == Bold.should_parse(walker, tree, tree.root, [])
    end
  end

  test "parse source code" do
    input = """
    oi **Some bold**
     no bold
    """

    assert {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

    assert %{
             children: [
               %{content: "oi ", level: 1, name: :p},
               %{
                content: {:empty, %{}},
                level: 1,
                name: :strong,
                children: [%{content: "Some bold", level: 2, name: :p}],
              },
              %{content: "\n no bold\n", level: 1, name: :p}
             ],
             content: :empty,
             level: 0,
             name: :empty,
             parent: :empty
           } = NaryTree.to_map(tree)
  end
end
