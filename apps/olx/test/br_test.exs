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
      name: :problem,
      content: :empty,
      children: [
        %{
          name: :p,
          content: "a",
          children: [
            %{
              name: :br,
              content: :empty
            }
          ]
        }
      ]
    } = NaryTree.to_map(tree)

    NaryTree.print_tree(tree, fn x -> "#{x.name}:#{x.content}" end)
    # assert content == "Hello\n"
  end
end
