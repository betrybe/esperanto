defmodule Esperanto.Parsers.LinkParseTest do
  alias Esperanto.Parsers.Img
  alias Esperanto.Parsers.Link
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  use ExUnit.Case

  describe "should_parse/4" do
    test "when input matches the regex, Then should_parse has to return true" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "[link](http://img.jpg) some "}

      assert true == Link.should_parse(walker, tree, tree.root, [])
    end

    test "when input does not matches the regex, Then should_parse has to return false" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "Some text ![alt](http://img.jpg"}

      assert false == Img.should_parse(walker, tree, tree.root, [])
    end
  end

  test "plain text with link" do
    input = "Some text [link](http://img.jpg)"

    {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

    %{
      children: [
        %{
          children: [
            %{
              content: {"link", %{href: "http://img.jpg"}},
              level: 2,
              name: "a"
            }
          ],
          content: "Some text ",
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
