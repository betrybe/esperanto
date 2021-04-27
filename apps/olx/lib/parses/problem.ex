defmodule Olx.Parsers.Problem do
  @behaviour Olx.Parser

  @impl Olx.Parser
  def should_parse(_, _, _, _), do: true

  @impl Olx.Parser
  def parse(input, _, _, opts) do
    tree = NaryTree.new(NaryTree.Node.new :problem)
    parsers = Keyword.get(opts, :parsers, [])
    astify("", input, tree, nil, parsers, :find_parse)
  end

  # No more input finished the parser
  def astify("", "", tree,_node , _parsers, _selected_parser) do
    tree
  end

  # No more input finish using the fallback parser
  def astify(input, "", tree, node, parsers, nil) do
    astify(input, "", tree, node, parsers, {Olx.Rarser.PlainText, []})
  end

  # Parser found, execute-it
  def astify(input, rest, tree, node, parsers, {parser, opts}) do
    {node, input_rest} = parser.parser(input, tree, node, opts)
    tree = NaryTree.add_child(tree, node)
    astify("", input_rest <> rest,node, tree, parsers, nil)
  end

  # Find parser
  def astify(input, rest, tree, node, parsers, :find_parse) do
    selected_parsers = select_parse(input, tree, node, parsers)
    astify(input, rest, tree, node, parsers, selected_parsers)
  end

  # no parser found,  walk
  def astify(input, rest, tree, node, parsers, :walk) do
    {next, rest} = String.split_at(rest, 1)
    astify(input <> next, rest, tree, node, parsers, :find_parse)
  end

  def select_parse(_input, [parse]) do
    parse
  end

  def select_parse(_input, []) do
    :find_parse
  end

  def select_parse(input, tree, node, parsers) do
    filtered_parsers = Enum.filter(parsers, fn {parser, opts} ->
      apply(parser, :should_parse, [input, tree, node, parsers, opts])
    end)
    select_parse(input, filtered_parsers)
  end

end
