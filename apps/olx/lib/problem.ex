defmodule Trybe.Esperanto.Olx.Problem do
  alias Trybe.Esperanto.Walker
  alias Trybe.Esperanto.Parsers.TopLevel

  def parse(input) do
    label = {Trybe.Esperanto.Olx.Parsers.Label, nil}
    choice = {Trybe.Esperanto.Olx.Parsers.Choice, nil}
    tree = NaryTree.new(NaryTree.Node.new(:problem))
    input = Walker.start(input)
    TopLevel.parse(input, tree, tree.root, parsers: TopLevel.default_parsers() ++ [label, choice])
  end
end