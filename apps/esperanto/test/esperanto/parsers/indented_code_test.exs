defmodule Esperanto.Parsers.IndentedParseTest do
  alias Esperanto.Walker
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Parsers.IndentedCode

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

    {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

    NaryTree.to_list(tree)

    %{
      children: [
        %{
          children: [
            %{
              children: [
                %{
                  content: "\n    Some\n     \tCode\n",
                  level: 3,
                  name: :code
                }
              ],
              content: :empty,
              level: 2,
              name: :pre
            },
            %{
              content: " NoCode\n",
              level: 2,
              name: :p
            }
          ],
          content: "oi",
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
