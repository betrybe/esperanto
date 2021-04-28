defmodule Olx.Parsers.PlainText do
  alias Olx.Walker

  @behaviour Olx.Parser

  @impl Olx.Parser

  def parse(walker, tree, parent_id, _opts) do
    node = NaryTree.Node.new(:div, walker.input)
    tree = NaryTree.add_child(tree, node, parent_id)
    {tree, Walker.consume_input(walker)}
  end

  @impl Olx.Parser
  def should_parse(_, _, _, _), do: false
end
