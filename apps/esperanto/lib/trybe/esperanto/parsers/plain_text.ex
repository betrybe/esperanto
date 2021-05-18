defmodule Esperanto.Parsers.PlainText do
  @moduledoc """
  Parse content as a plain text <p>
  """

  alias Esperanto.Parsers.TopLevel
  alias Esperanto.ParserUtility
  alias Esperanto.Walker
  @behaviour Esperanto.Parser

  @impl Esperanto.Parser

  def parse(%Walker{input: ""} = walker, tree, _parent_id, _opts) do
    {tree, walker}
  end

  def parse(walker, tree, parent_id, opts) do
    {input, _rest} = String.split_at(walker.input, 1)

    sibiling =
      NaryTree.get(tree, parent_id)
      |> ParserUtility.find_sibiling(tree)

    {tree, _parent_id} =
      case astify(input, sibiling) do
        nil ->
          new_node = NaryTree.Node.new(:p, input)
          tree = NaryTree.add_child(tree, new_node, parent_id)
          {tree, new_node.id}

        updated_node ->
          {node, tree} = NaryTree.get_and_update(tree, updated_node.id, &{&1, updated_node})
          {tree, node.id}
      end

    TopLevel.parse(Walker.consume_input(walker, 1), tree, parent_id, opts)
  end

  defp astify(input, %NaryTree.Node{name: :p, content: :empty, children: []} = node) do
    %NaryTree.Node{node | content: input}
  end

  defp astify(input, %NaryTree.Node{name: :p, content: content, children: []} = node)
       when is_binary(content) do
    %NaryTree.Node{node | content: content <> input}
  end

  defp astify(_input, _node), do: nil

  @impl Esperanto.Parser
  def should_parse(%Walker{rest: ""}, _, _, _), do: true
  def should_parse(%Walker{rest: :barried}, _, _, _), do: true
  def should_parse(_, _, _, _), do: false
end
