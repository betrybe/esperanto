defmodule Esperanto.ParseTest do
  use ExUnit.Case
  doctest Esperanto.Parse

  test "top level AST is problem" do
    input = ~S"""
    Hello world.
    """
    assert Esperanto.Parse.to_ast(input) == {:problem, %{}, [{:p, %{}, "Hello world.\n"}]}
  end

  test "When using ( ) Then surround it with choicegroup" do
    input = ~S"""
    ( ) item 1
    ( ) item 2
    """
    assert Esperanto.Parse.to_ast(input) == {:problem, %{}, [{:p, %{}, [{:choicegroup, %{}, [{:choice, %{correct: false}, "item 1"}, {:choice, %{correct: false}, "item 2"}]}]}]}
  end

  test "Label parsing" do
    input = ~S"""
    >>This is a label<<
    ( ) item 1
    ( ) item 2
    """
    assert Esperanto.Parse.to_ast(input) == {
      :problem,
      %{},
      [
        {:label, %{}, "This is a label"},
        {:choicegroup, %{}, [{:choice, %{correct: false}, "item 1"}, {:choice, %{correct: false}, "item 2"}]}
      ]
    }
  end

  test "Label parsing with rich text" do
    input = ~S"""
    >>This is *a* label<<
    ( ) item 1
    ( ) item 2
    """
    assert Esperanto.Parse.to_ast(input) == {
      :problem,
      %{},
      [
        {:label, %{}, ["This is ", {:strong, %{}, "a"}, " label"]},
        {:choicegroup, %{}, [{:choice, %{correct: false}, "item 1"}, {:choice, %{correct: false}, "item 2"}]}
      ]
    }
  end
end
