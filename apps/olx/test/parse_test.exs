defmodule Esperanto.ParseTest do
  use ExUnit.Case

  test "top level AST is problem" do
    input = ~S"""
    """

    {tree, _} = Olx.parse(input, parsers: [])
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

    {tree, _} = Olx.parse(input, parsers: [])

    %{
      children: [%{content: content}]
    } = NaryTree.to_map(tree)

    assert content == "Hello\n"
  end

  test "plain text with label" do
    input = ~S"""
    >>Hello<<
    """

    {tree, _} = Olx.parse(input, parsers: [])

    %{
      children: [
        %{
          content: :empty,
          name: "label",
          children: [
            %{
              content: content
            }
          ]
        },
        %{
          content: "\n"
        }
      ]
    } = NaryTree.to_map(tree)

    assert content == "Hello"
  end

  test "plain text with label and choice" do
    input = ~S"""
    >>Hello<<
    ( ) Apple
    """

    {tree, _} = Olx.parse(input, parsers: [])

    %{
      children: [
        %{
          content: :empty,
          name: "label",
          children: [
            %{
              content: "Hello"
            }
          ]
        },
        %{
          name: "choice",
          content: :empty,
          children: [
            %{
              content: content
            }
          ]
        }
      ]
    } = NaryTree.to_map(tree)

    assert String.trim(content) == "Apple"
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
