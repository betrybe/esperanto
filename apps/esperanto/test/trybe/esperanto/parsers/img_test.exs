defmodule Esperanto.Parsers.ImgParseTest do
  alias Esperanto.Walker
  alias Esperanto.Parsers.TopLevel
  use ExUnit.Case

  test "when input matches the regex, Then should_parse has to return true" do
    tree = NaryTree.new(NaryTree.Node.new(:problem))
    walker = %Walker{input: "![alt](http://img.jpg) some "}

    assert true == Esperanto.Parsers.Img.should_parse(walker, tree, tree.root, [])
  end

  test "when input does not matches the regex, Then should_parse has to return false" do
    tree = NaryTree.new(NaryTree.Node.new(:problem))
    walker = %Walker{input: "Some text ![alt](http://img.jpg"}

    assert false == Esperanto.Parsers.Img.should_parse(walker, tree, tree.root, [])
  end

  test "plain text with img break" do
    input = "Some text ![alt](http://img.jpg)"

    {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

    %{
      children: [
        %{
          children: [
            %{
              content: {:empty, %{alt: "alt", src: "http://img.jpg"}},
              level: 2,
              name: "img",
            }
          ],
          content: "Some text ",
          level: 1,
          name: :p,
        }
      ],
      content: :empty,
      level: 0,
      name: :empty,
      parent: :empty
    } = NaryTree.to_map(tree)
  end
end
