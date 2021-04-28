defmodule Olx.Parsers.TopLevel do
  alias Olx.Walker
  @behaviour Olx.Parser

  @moduledoc """
  Top level parser\n
  This parser selected which parser will be used based on `should_parse` call from other modules
  """
  @impl Olx.Parser
  def should_parse(_, _, _, _), do: true

  @impl Olx.Parser
  def parse(walker, tree, _, opts) do
    tree = tree || NaryTree.new()
    parsers = Keyword.get(opts, :parsers, [])
    astify(walker, tree, tree.root, parsers, :find_parse)
  end

  # No more input finished the parser
  defp astify(
         %Olx.Walker{input: "", rest: ""} = walker,
         tree,
         _parent_id,
         _parsers,
         _selected_parser
       ) do
    {tree, walker}
  end

  # No more input finish using the fallback parser
  defp astify(%Olx.Walker{rest: ""} = input, tree, parent_id, parsers, :find_parse) do
    astify(input, tree, parent_id, parsers, {Olx.Parsers.PlainText, []})
  end

  # Parser found, execute it
  defp astify(input, tree, parent_id, parsers, {parser, opts}) do
    {tree, walker} = parser.parse(input, tree, parent_id, opts)
    astify(walker, tree, parent_id, parsers, nil)
  end

  # Find parser
  defp astify(walker, tree, parent_id, parsers, :find_parse) do
    selected_parsers = select_parse(walker, tree, parent_id, parsers)
    astify(walker, tree, parent_id, parsers, selected_parsers)
  end

  # no parser found,  walk
  defp astify(walker, tree, parent_id, parsers, :walk) do
    walker = Walker.walk(walker)
    astify(walker, tree, parent_id, parsers, :find_parse)
  end

  # Only one parse found, ready to go
  defp select_parse(_input, [parse]) do
    parse
  end

  # no parser found,  walk
  defp select_parse(_input, []) do
    :walk
  end

  # find parsers that should be executed
  defp select_parse(walker, tree, parent_id, parsers) do
    filtered_parsers =
      Enum.filter(parsers, fn {parser, opts} ->
        apply(parser, :should_parse, [walker, tree, parent_id, parsers, opts])
      end)

    select_parse(walker, filtered_parsers)
  end
end
