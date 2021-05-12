defmodule Esperanto.Parsers.InlineParseTest do
  alias Esperanto.Walker
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Parsers.InlineFencedCode

  use ExUnit.Case

  describe "should_parse/4" do
    test "when input matches the regex, Then should_parse has to return true" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "`"}

      assert true == InlineFencedCode.should_parse(walker, tree, tree.root, [])
    end

    test "when input does not matches the regex, Then should_parse has to return false" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "```"}

      assert false == InlineFencedCode.should_parse(walker, tree, tree.root, [])
    end
  end

  test "parse source code" do
    input = """
    oi `Some Code`
     NoCode
    """

    assert {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

    assert %{
             children: [
               %{
                 children: [
                   %{
                     content: "Some Code",
                     level: 2,
                     name: :code
                   },
                   %{
                     content: "\n NoCode\n",
                     level: 2,
                     name: :p
                   }
                 ],
                 content: "oi ",
                 level: 1,
                 name: :p
               }
             ],
             content: :empty,
             level: 0,
             name: :empty,
             parent: :empty
           } = NaryTree.to_map(tree)
  end
end
