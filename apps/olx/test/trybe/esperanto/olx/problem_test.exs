defmodule Esperanto.Olx.ParseTest do
  alias Esperanto.Olx.Problem
  use ExUnit.Case

  test "top level AST is problem" do
    input = ~S"""
    """

    {tree, _} = Problem.parse(input)
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

    {tree, _} = Problem.parse(input)

    %{
      children: [%{content: content}]
    } = NaryTree.to_map(tree)

    assert content == "Hello\n"
  end

  test "plain text with label" do
    input = ~S"""
    >>Hello<<
    """

    {tree, _} = Problem.parse(input)

    %{
      children: [
        %{
          content: :empty,
          name: :label,
          children: [
            %{content: content, level: 2, name: :p}
          ]
        },
        %{content: "\n", level: 1, name: :p}
      ],
      content: :empty,
      level: 0,
      name: :problem,
      parent: :empty
    } = NaryTree.to_map(tree)

    assert content == "Hello"
  end

  test "plain text with label and choice" do
    input = ~S"""
    >>Hello<<
    ( ) Apple
    """

    {tree, _} = Problem.parse(input)

    %{
      children: [
        %{
          content: :empty,
          name: :label,
          children: [
            %{
              content: "Hello",
              level: 2,
              name: :p
            }
          ]
        },
        %{
          name: :choice,
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
end
