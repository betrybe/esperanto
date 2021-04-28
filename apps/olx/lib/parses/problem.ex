defmodule Olx.Parsers.Problem do

  alias Olx.Walker

  def parse(input, opts) do
    tree = NaryTree.new(NaryTree.Node.new :problem)
    input = Walker.start(input)
    Olx.Parsers.TopLevel.parse(input, tree, nil, opts)
  end

end
