defmodule Olx.Parsers.EnclosingTag do
  alias Olx.Walker
  alias Olx.Parsers.TopLevel
  @behaviour Olx.Parser
  @impl Olx.Parser

  @moduledoc """
  Simple enclose the contents between `:start_delimiter` and :`end_delimiter` with the `enclosing_tag`
  """

  @doc """
  opts
    * :start_delimiter
    * :end_delimiter
    * :enclosing_tag
  """
  def parse(walker, tree, parent_id, opts) do
    start_delimiter = Keyword.get(opts, :start_delimiter)
    end_delimiter = Keyword.get(opts, :end_delimiter)
    tag = Keyword.get(opts, :enclosing_tag)

    if !matchs(walker.input, start_delimiter) do
      raise "Expected to find #{end_delimiter} at line:#{walker.line},column:#{walker.column}. Found: #{
              walker.input
            }"
    end

    node = NaryTree.Node.new(tag)
    tree = NaryTree.add_child(tree, node, parent_id)

    walker =
      walker
      |> Walker.consume_input()
      |> Walker.with_barrier(end_delimiter)

    {tree, walker} = TopLevel.parse(walker, tree, node.id, opts)
    {tree, Walker.destroy_barrier(walker)}
  end

  @impl Olx.Parser
  def should_parse(%Walker{input: input}, _, _, opts) do
    start_delimiter = Keyword.get(opts, :start_delimiter)
    matchs(input, start_delimiter)
  end

  defp matchs(input, delimiter) when is_binary(delimiter) do
    matchs(input, Regex.compile!(delimiter))
  end
  defp matchs(input, delimiter), do: String.match?(input, delimiter)
end
