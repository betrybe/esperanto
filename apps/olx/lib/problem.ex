defmodule Esperanto.Olx.Problem do
  alias Esperanto.Walker
  alias Esperanto.Parsers.TopLevel

  def parse(input) do
    label = {Esperanto.Olx.Parsers.Label, nil}
    choice = {Esperanto.Olx.Parsers.Choice, nil}
    tree = NaryTree.new(NaryTree.Node.new(:problem))
    input = Walker.start(input)
    TopLevel.parse(input, tree, tree.root, parsers: TopLevel.default_parsers() ++ [label, choice])
  end
end
