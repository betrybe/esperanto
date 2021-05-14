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
      {Esperanto.Olx.Parsers.CorrectChoice, nil}
    ]

    tree = NaryTree.new(NaryTree.Node.new(:problem))
    input = Walker.start(input)
    TopLevel.parse(input, tree, tree.root, parsers: TopLevel.default_parsers() ++ parsers)
  end
end
