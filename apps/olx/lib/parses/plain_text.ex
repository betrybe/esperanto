defmodule Olx.Parsers.PlainText do
  alias Olx.Walker

  @behaviour Olx.Parser

  @impl Olx.Parser
  def parse(walker, _tree, %NaryTree.Node{name: :empty, content: :empty, children: []} = node, _opts) do
    { %NaryTree.Node{node | name: :div, content: walker.input}, Walker.consume_input(walker) }
  end
  def parse(walker, _tree, nil, _opts) do
    { NaryTree.Node.new(:div, walker.input), Walker.consume_input(walker)  }
  end
  @impl Olx.Parser
  def should_parse(_, _, _, _), do: false

end
