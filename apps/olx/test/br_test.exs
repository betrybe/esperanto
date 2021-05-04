defmodule Esperanto.BrParseTest do
  alias Olx.Walker
  use ExUnit.Case

  test "when input matches the regex, Then should_parse has to return true" do
    tree = NaryTree.new(NaryTree.Node.new(:problem))
    walker = %Walker{input: "  \nOi"}

    assert true == Olx.Parsers.Br.should_parse(walker, tree, tree.root, [])
  end

  test "when input does not matches the regex, Then should_parse has to return false" do
    tree = NaryTree.new(NaryTree.Node.new(:problem))
    walker = %Walker{input: "Oi  \nOi"}

    assert false == Olx.Parsers.Br.should_parse(walker, tree, tree.root, [])
  end

  test "plain text with line break" do
    input = "a  \nb"

    {tree, _} = Olx.parse(input, parsers: [])

    %{
      children: [
        %{
          children: [
            %{
              content: :empty,
              level: 2,
              name: :br,
            },
            %{content: "b", level: 2, name: :p, }
          ],
          content: "a",
          level: 1,
          name: :p,
        }
      ],
      content: :empty,
      level: 0,
      name: :problem,
      parent: :empty
    } = NaryTree.to_map(tree)

  end
end
