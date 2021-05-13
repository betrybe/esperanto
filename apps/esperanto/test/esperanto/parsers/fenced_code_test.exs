defmodule Esperanto.Parsers.FencedCodeTest do
  alias Esperanto.Parsers.FencedCode
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  use ExUnit.Case

  describe "should_parse/4" do
    test "when input matches the regex, Then should_parse has to return true" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "```"}

      assert true == FencedCode.should_parse(walker, tree, tree.root, [])
    end

    test "when input does not matches the regex, Then should_parse has to return false" do
      tree = NaryTree.new(NaryTree.Node.new(:problem))
      walker = %Walker{input: "``"}

      assert false == FencedCode.should_parse(walker, tree, tree.root, [])
    end
  end

  test "parse source code" do
    input = """
    oi `Some Code`
     NoCode
    ```
    some
       code
    block
    ```
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
                     children: [
                       %{
                         children: [
                           %{
                             content: "\nsome\n   code\nblock\n",
                             level: 4,
                             name: :code
                           }
                         ],
                         content: :empty,
                         level: 3,
                         name: :pre
                       },
                       %{
                         content: "\n",
                         level: 3,
                         name: :p
                       }
                     ],
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
