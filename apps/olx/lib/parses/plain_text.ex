defmodule Olx.Parsers.PlainText do
  alias Olx.ASTNode

  @behaviour Olx.Parser

  @impl Olx.Parser
  def parse(input, _tree, %NaryTree.Node{name: :empty, content: :empty, children: []} = node, _opts) do
    { %NaryTree.Node{node | name: :div, content: input}, "" }
  end
  def parse(input, _tree, nil, _opts) do
    { NaryTree.Node.new(:div, input), "" }
  end
end
