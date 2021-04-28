defmodule Olx.Parsers.TopLevel do
  alias Olx.Walker
  @behaviour Olx.Parser


  @impl Olx.Parser
  def should_parse(_, _, _, _), do: true

  @impl Olx.Parser
  def parse(walker, tree, _, opts) do
    tree = tree || NaryTree.new()
    parsers = Keyword.get(opts, :parsers, [])
    astify(walker, tree, nil, parsers, :find_parse)
  end

  # No more input finished the parser
  def astify(%Olx.Walker{input: "", rest: ""}, tree, _node , _parsers, _selected_parser) do
    tree
  end

  # No more input finish using the fallback parser
  def astify(%Olx.Walker{rest: ""} = input, tree, node, parsers, :find_parse) do
    astify(input, tree, node, parsers, {Olx.Parsers.PlainText, []})
  end

  # Parser found, execute-it
  def astify(input, tree, node, parsers, {parser, opts}) do
    {node, walker} = parser.parse(input, tree, node, opts)
    tree = NaryTree.add_child(tree, node)
    astify(walker, tree, node, parsers, nil)
  end

  # Find parser
  def astify(walker, tree, node, parsers, :find_parse) do
    selected_parsers = select_parse(walker, tree, node, parsers)
    astify(walker, tree, node, parsers, selected_parsers)
  end

  # no parser found,  walk
  def astify(walker, tree, node, parsers, :walk) do
    walker = Walker.walk(walker)
    astify(walker, tree, node, parsers, :find_parse)
  end

  def select_parse(_input, [parse]) do
    parse
  end

  def select_parse(_input, []) do
    :walk
  end

  def select_parse(walker, tree, node, parsers) do
    filtered_parsers = Enum.filter(parsers, fn {parser, opts} ->
      apply(parser, :should_parse, [walker, tree, node, parsers, opts])
    end)
    select_parse(walker, filtered_parsers)
  end

end