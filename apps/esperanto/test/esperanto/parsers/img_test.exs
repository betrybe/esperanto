defmodule Esperanto.Parsers.ImgParseTest do
  alias Esperanto.Parsers.Img
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker
  use ExUnit.Case

  describe "should_parse/4" do
    test "when input matches the regex, Then should_parse has to return true" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "![alt](http://img.jpg) some "}

      assert true == Img.should_parse(walker, tree, tree.root, [])
    end

    test "when input does not matches the regex, Then should_parse has to return false" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "Some text ![alt](http://img.jpg"}

      assert false == Img.should_parse(walker, tree, tree.root, [])
    end
  end

  test "plain text with img" do
    input = "Some text ![alt](http://img.jpg)"

    {tree, _} = TopLevel.parse(Walker.start(input), nil, nil, [])

    assert %{
             children: [
               %{
                 content: "Some text ",
                 level: 1,
                 name: :p
               },
               %{
                 content: {:empty, %{alt: "alt", src: "http://img.jpg"}},
                 level: 1,
                 name: "img"
               }
             ],
             content: :empty,
             level: 0,
             name: :empty,
             parent: :empty
           } = NaryTree.to_map(tree)
  end
end
