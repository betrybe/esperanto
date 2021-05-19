defmodule Esperanto.Parsers.IndentedParseTest do
  alias Esperanto.Parsers.IndentedCode
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  use ExUnit.Case

  describe "should_parse/4" do
    test "when input matches the regex, Then should_parse has to return true" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "\t"}

      assert true == IndentedCode.should_parse(walker, tree, tree.root, [])
    end

    test "when input does not matches the regex, Then should_parse has to return false" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "   three space is not enough"}

      assert false == IndentedCode.should_parse(walker, tree, tree.root, [])
    end
  end

  test "parse source code" do
    input = """
    oi
        Some
         \tCode
     NoCode
    """

    assert {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

    NaryTree.to_list(tree)

    assert %{
             children: [
               %{content: "oi", level: 1, name: :p},
               %{
                 children: [
                   %{content: "Some\n \tCode\n", level: 2, name: :code}
                 ],
                 content: :empty,
                 level: 1,
                 name: :pre
               },
               %{content: " NoCode\n", level: 1, name: :p}
             ],
             content: :empty,
             level: 0,
             name: :empty,
             parent: :empty
           } = NaryTree.to_map(tree)
  end
end
