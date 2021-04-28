defmodule Esperanto.ParseTest do
  use ExUnit.Case

  test "top level AST is problem" do
    input = ~S"""
    """

    {node, _} = Olx.parse(input, parsers: [])
    tree = NaryTree.new(node)
    root = tree.root

    %NaryTree{
      nodes: %{
        ^root => %NaryTree.Node{
          children: [],
          content: :empty,
          id: ^root,
          level: 0,
          name: :problem,
          parent: :empty
        }
      },
      root: ^root
    } = tree
  end

  test "plain text" do
    input = ~S"""
    Hello
    """

    {node, _} = Olx.parse(input, parsers: [])

    tree =
      node
      |> NaryTree.new()
      |> NaryTree.to_map()

    %{
      children: [%{content: content}]
    } = tree

    assert content == "Hello\n"
  end

  # test "When using (x) Then the correct attribute is set to true" do
  #   input = ~S"""
  #   ( ) item 2
  #   (x) item 1
  #   ( ) item 3
  #   """
  #   assert Esperanto.Parse.to_ast(input) == {:problem, %{}, [{:p, %{}, [{:choicegroup, %{}, [{:choice, %{correct: true}, "item 1"}, {:choice, %{correct: false}, "item 2"}]}]}]}
  # end

  # test "When using ( ) Then surround it with choicegroup" do
  #   input = ~S"""
  #   ( ) item 1
  #   ( ) item 2
  #   """
  #   assert Esperanto.Parse.to_ast(input) == {:problem, %{}, [{:p, %{}, [{:choicegroup, %{}, [{:choice, %{correct: false}, "item 1"}, {:choice, %{correct: false}, "item 2"}]}]}]}
  # end

  # test "Label parsing" do
  #   input = ~S"""
  #   >>This is a label<<
  #   ( ) item 1
  #   ( ) item 2
  #   """
  #   assert Esperanto.Parse.to_ast(input) == {
  #     :problem,
  #     %{},
  #     [
  #       {:label, %{}, "This is a label"},
  #       {:choicegroup, %{}, [{:choice, %{correct: false}, "item 1"}, {:choice, %{correct: false}, "item 2"}]}
  #     ]
  #   }
  # end

  # test "Label parsing with rich text" do
  #   input = ~S"""
  #   >>This is *a* label<<
  #   ( ) item 1
  #   ( ) item 2
  #   """
  #   assert Esperanto.Parse.to_ast(input) == {
  #     :problem,
  #     %{},
  #     [
  #       {:label, %{}, ["This is ", {:strong, %{}, "a"}, " label"]},
  #       {:choicegroup, %{}, [{:choice, %{correct: false}, "item 1"}, {:choice, %{correct: false}, "item 2"}]}
  #     ]
  #   }
  # end
end
