defmodule Esperanto.Parsers.ItalicTest do
  alias Esperanto.Parsers.Italic
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  use ExUnit.Case

  describe "should_parse/4" do
    test "when input matches the regex, Then should_parse has to return true" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "*1"}

      assert true == Italic.should_parse(walker, tree, tree.root, [])
    end

    test "when input does not matches the regex, Then should_parse has to return false" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "**"}

      assert false == Italic.should_parse(walker, tree, tree.root, [])
    end
  end

  test "parse source code" do
    input = """
    oi *Some italic*
     no italic
    """

    assert {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

    assert %{
             children: [
               %{content: "oi ", level: 1, name: :p},
               %{
                 content: {:empty, %{}},
                 level: 1,
                 name: :em,
                 children: [%{content: "Some italic", level: 2, name: :p}]
               },
               %{content: "\n no italic\n", level: 1, name: :p}
             ],
             content: :empty,
             level: 0,
             name: :empty,
             parent: :empty
           } = NaryTree.to_map(tree)
  end
end
