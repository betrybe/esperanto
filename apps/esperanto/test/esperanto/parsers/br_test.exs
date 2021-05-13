defmodule Esperanto.Parsers.BrParseTest do
  alias Esperanto.Parsers.Br
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  use ExUnit.Case

  test "when input matches the regex, Then should_parse has to return true" do
    tree =
      :problem
      |> NaryTree.Node.new()
      |> NaryTree.new()

    walker = %Walker{input: "  \nOi"}

    assert true == Br.should_parse(walker, tree, tree.root, [])
  end

  test "when input does not matches the regex, Then should_parse has to return false" do
    tree =
      :problem
      |> NaryTree.Node.new()
      |> NaryTree.new()

    walker = %Walker{input: "Oi  \nOi"}

    assert false == Br.should_parse(walker, tree, tree.root, [])
  end

  test "plain text with line break" do
    {tree, _} =
      "a  \nb"
      |> Walker.start(input)
      |> TopLevel.parse(nil, nil, [])

    %{
      children: [
        %{
          children: [
            %{
              content: :empty,
              level: 2,
              name: :br
            },
            %{content: "b", level: 2, name: :p}
          ],
          content: "a",
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
