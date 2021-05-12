defmodule Esperanto.Parsers.TopLevel do
  alias Esperanto.Walker
  @behaviour Esperanto.Parser
  @default_parsers [
    {Esperanto.Parsers.PlainText, nil},
    {Esperanto.Parsers.Br, nil},
    {Esperanto.Parsers.Img, nil},
    {Esperanto.Parsers.Link, nil},
    {Esperanto.Parsers.IndentedCode, nil}
  ]

  @spec default_parsers :: list()
  def default_parsers, do: @default_parsers

  @moduledoc """
  Top level parser\n
  This parser selected which parser will be used based on `should_parse` call from other modules
  """
  @impl Esperanto.Parser
  def should_parse(_, _, _, _), do: true

  @impl Esperanto.Parser
  def parse(walker, nil, nil, opts) do
    tree = NaryTree.new(NaryTree.Node.new())
    parse(walker, tree, tree.root, opts)
  end

  def parse(walker, tree, parent_id, opts) do
    opts = Keyword.merge([parsers: @default_parsers], opts)
    astify(walker, tree, parent_id, opts, :find_parse)
  end

  # No more input finished the parser
  defp astify(
         %Walker{input: "", rest: ""} = walker,
         tree,
         _parent_id,
         _opts,
         _selected_parser
       ) do
    {tree, walker}
  end

  # No more input finished the parser
  defp astify(
         %Walker{rest: :barried} = walker,
         tree,
         parent_id,
         opts,
         _
       ) do
    # one last chance
    case select_parse(walker, tree, parent_id, opts) do
      {parser, _opts} -> parser.parse(walker, tree, parent_id, opts)
      _ -> {tree, walker}
    end
  end

  # Parser found, execute it
  defp astify(input, tree, parent_id, opts, {parser, _opts}) do
    {tree, walker} = parser.parse(input, tree, parent_id, opts)
    astify(walker, tree, parent_id, opts, :find_parse)
  end

  # Find parser
  defp astify(walker, tree, parent_id, opts, :find_parse) do
    selected_parsers = select_parse(walker, tree, parent_id, opts)
    astify(walker, tree, parent_id, opts, selected_parsers)
  end

  # no parser found,  walk
  defp astify(walker, tree, parent_id, opts, :walk) do
    IO.puts()
    walker = Walker.walk(walker)
    astify(walker, tree, parent_id, opts, :find_parse)
  end

  # Only one parse found, ready to go
  defp select_parse(_input, [parse]) do
    parse
  end

  # no parser found,  walk
  defp select_parse(_input, []) do
    :walk
  end

  # error more then one parser found. Grammar is ambiguous
  defp select_parse(input, parsers) do
    parsers =
      parsers
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(&Atom.to_string/1)
      |> Enum.join(", ")

    raise "Grammar is ambiguos! More then one parser found for input \"#{input.input}\": #{
            parsers
          }."
  end

  # find parsers that should be executed
  defp select_parse(walker, tree, parent_id, opts) do
    parsers = Keyword.get(opts, :parsers)

    filtered_parsers =
      Enum.filter(parsers, fn {parser, opts} ->
        parser.should_parse(walker, tree, parent_id, opts)
      end)

    # case more than 1 parse is found, give priority to any other than PlainText
    if Enum.count(filtered_parsers) > 1 do
      filtered_parsers =
        Enum.filter(filtered_parsers, fn {parser, _opts} ->
          parser != Esperanto.Parsers.PlainText
        end)

      select_parse(walker, filtered_parsers)
    else
      select_parse(walker, filtered_parsers)
    end
  end
end
