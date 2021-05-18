defmodule Esperanto.Olx.Problem do
  @moduledoc """
  Parse and OLX problem
  """

  alias Esperanto.Parser
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  def parse(input) do
    parsers = [
      {Esperanto.Olx.Parsers.Label, nil},
      {Esperanto.Olx.Parsers.IncorrectChoice, nil},
      {Esperanto.Olx.Parsers.CorrectChoice, nil},
      {Esperanto.Olx.Parsers.ChoiceHint, nil}
    ]

    walker = if String.ends_with?(input, "\n") do
      Walker.start(input)
    else
      Walker.start(input <> "\n")
    end

    multiple_choice_response = NaryTree.Node.new(:multiplechoiceresponse)

    tree =
      NaryTree.Node.new(:problem)
      |> NaryTree.new()
      |> NaryTree.add_child(multiple_choice_response)

    TopLevel.parse(walker, tree, multiple_choice_response.id,
      parsers: TopLevel.default_parsers() ++ parsers
    )
  end

  def to_xml(input) do
    input
    |> parse()
    |> elem(0)
    |> Parser.to_xml()
  end
end
