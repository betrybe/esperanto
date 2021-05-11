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

    {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

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
    } = IO.inspect(NaryTree.to_map(tree))
  end
end
