defmodule Esperanto.Olx.Problem do
  @moduledoc """
  Parse and OLX problem
  """

  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  def parse(input) do
    parsers = [
      {Esperanto.Olx.Parsers.Label, nil},
      {Esperanto.Olx.Parsers.IncorrectChoice, nil},
      {Esperanto.Olx.Parsers.CorrectChoice, nil},
      {Esperanto.Olx.Parsers.ChoiceHint, nil}
    ]

    input = Walker.start(input)
    multiple_choice_response = NaryTree.Node.new(:multiplechoiceresponse)

    tree =
      NaryTree.Node.new(:problem)
      |> NaryTree.new()
      |> NaryTree.add_child(multiple_choice_response)

    TopLevel.parse(input, tree, multiple_choice_response.id,
      parsers: TopLevel.default_parsers() ++ parsers
    )
  end
end
