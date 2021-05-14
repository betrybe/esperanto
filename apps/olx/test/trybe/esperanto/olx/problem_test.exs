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

    assert %{
             children: [
               %{
                 children: [
                   %{
                     content: "Hello\n",
                     level: 2,
                     name: :p
                   }
                 ],
                 content: :empty,
                 level: 1,
                 name: :multiplechoiceresponse
               }
             ],
             content: :empty,
             level: 0,
             name: :problem,
             parent: :empty
           } = NaryTree.to_map(tree)
  end

  test "plain text with label" do
    input = ~S"""
    >>Hello<<
    """

    {tree, _} = Problem.parse(input)

    assert %{
             children: [
               %{
                 children: [
                   %{
                     children: [
                       %{
                         content: "Hello",
                         level: 3,
                         name: :p
                       }
                     ],
                     content: {:empty, %{}},
                     level: 2,
                     name: :label
                   },
                   %{content: "\n", level: 2, name: :p}
                 ],
                 content: :empty,
                 level: 1,
                 name: :multiplechoiceresponse
               }
             ],
             content: :empty,
             level: 0,
             name: :problem,
             parent: :empty
           } = NaryTree.to_map(tree)
  end

  test "plain text with label and choice" do
    input = ~S"""
    >>Hello<<
    ( ) Apple
    (x) Orange
    """

    {tree, _} = Problem.parse(input)

    assert %{
             children: [
               %{
                 children: [
                   %{
                     children: [
                       %{
                         content: "Hello",
                         level: 3,
                         name: :p
                       }
                     ],
                     content: {:empty, %{}},
                     level: 2,
                     name: :label
                   },
                   %{
                     children: [
                       %{
                         children: [
                           %{
                             content: " Apple",
                             level: 4,
                             name: :p
                           }
                         ],
                         content: {:empty, %{correct: false}},
                         level: 3,
                         name: :choice
                       },
                       %{
                         children: [
                           %{
                             content: " Orange",
                             level: 4,
                             name: :p
                           }
                         ],
                         content: {:empty, %{correct: true}},
                         level: 3,
                         name: :choice
                       }
                     ],
                     content: {:empty, %{type: "MultipleChoice"}},
                     level: 2,
                     name: :choicegroup
                   }
                 ],
                 content: :empty,
                 level: 1,
                 name: :multiplechoiceresponse
               }
             ],
             content: :empty,
             level: 0,
             name: :problem,
             parent: :empty
           } = NaryTree.to_map(tree)
  end
end
