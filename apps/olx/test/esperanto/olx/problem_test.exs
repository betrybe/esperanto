defmodule Esperanto.Olx.ParseTest do
  alias Esperanto.Olx.Problem
  use ExUnit.Case

  test "sintaxe inválida" do
    input = ~S"""
     {{não fechei o enunciado
      oi
    """

    assert_raise(
      RuntimeError,
      "trying to destroy a barrier of an unbarrier Walker. This shouldn`t never happen",
      fn ->
        Problem.parse(input)
      end
    )
  end

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
                   %{content: "\n", level: 2, name: :p},
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

  test "choice with fenced code" do
    # manual added leading white space to avoid beeing trimmed by IDEs
    input = ~s"""
    ( )#{" "}#{" "}
    ```
    code
    ```
    """

    {tree, _} = Problem.parse(input)

    assert %{
             children: [
               %{
                 children: [
                   %{
                     children: [
                       %{
                         children: [
                           %{
                             content: :empty,
                             level: 4,
                             name: :br
                           },
                           %{
                             children: [
                               %{
                                 content: "\ncode\n",
                                 level: 5,
                                 name: :code
                               }
                             ],
                             content: :empty,
                             level: 4,
                             name: :pre
                           }
                         ],
                         content: {:empty, %{correct: false}},
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

  test "plain text with label, choice and choice hint" do
    input = ~S"""
    >>Hello<<
    ( ) Apple {{incorrect}}
    (x) Orange {{correct}}
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
                   %{content: "\n", level: 2, name: :p},
                   %{
                     children: [
                       %{
                         children: [
                           %{
                             content: " Apple ",
                             level: 4,
                             name: :p
                           },
                           %{
                             children: [
                               %{content: "incorrect", level: 5, name: :p}
                             ],
                             content: {:empty, %{}},
                             level: 4,
                             name: :choicehint
                           }
                         ],
                         content: {:empty, %{correct: false}},
                         level: 3,
                         name: :choice
                       },
                       %{
                         children: [
                           %{
                             content: " Orange ",
                             level: 4,
                             name: :p
                           },
                           %{
                             children: [%{content: "correct", level: 5, name: :p}],
                             content: {:empty, %{}},
                             level: 4,
                             name: :choicehint
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

  test "converting to struct" do
    input = ~S"""
    >>Hello<<
    ( ) Apple {{incorrect}}
    (x) Orange {{correct}}
    """

    problem =
      input
      |> Problem.to_xml()
      |> Problem.to_struct()

    assert %{
             choices: [
               %{
                 choicehint: "<p>incorrect</p>",
                 content: "<p>Apple</p>",
                 is_correct: "false"
               },
               %{
                 choicehint: "<p>correct</p>",
                 content: "<p>Orange</p>",
                 is_correct: "true"
               }
             ],
             question: "<p>Hello</p>"
           } == problem
  end
end
