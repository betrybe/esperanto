defmodule Esperanto.Parsers.IndentedCode do
  @moduledoc """
  Parse an idented code with 4 space or tab
  """
  alias Esperanto.Walker

  @behaviour Esperanto.Parser

  @impl Esperanto.Parser
  def parse(walker, tree, parent_id, _opts) do
    {walker, content} = get_content(walker)
    pre = NaryTree.Node.new(:pre)
    code = NaryTree.Node.new(:code, content)

    tree = NaryTree.add_child(tree, pre, parent_id)
    tree = NaryTree.add_child(tree, code, pre.id)

    {tree, walker}
  end

  defp remove_first_level_indent(walker, indent \\ 0)

  defp remove_first_level_indent(walker, indent) when indent >= 4 do
    walker
  end
  defp remove_first_level_indent(%Walker{input: "", rest: ""}, indent) when indent < 4 do
    raise "Four level indention exected but not found"
  end
  defp remove_first_level_indent(%Walker{input: ""} = walker, indent) when indent < 4 do
    remove_first_level_indent(Walker.walk(walker), indent)
  end
  defp remove_first_level_indent(walker, indent) when indent < 4 do
    {input, _rest} = String.split_at(walker.input, 1)
    walker = Walker.consume_input(walker, 1)
    remove_first_level_indent(walker, indent + indent_for(input))
  end

  defp get_content(walker, content \\ "") do
    walker = remove_first_level_indent(walker)
    walker = Walker.walk_until(walker, ~r/\n$/)
    content = content <> walker.input
    walker = Walker.consume_input(walker)

    if has_4_level_indented(walker.rest) do
      get_content(walker, content)
    else
      {walker, content}
    end
  end

  @impl Esperanto.Parser
  def should_parse(%Walker{input: input, rest: ""}, _, _, _),
    do: has_4_level_indented(input)

  def should_parse(%Walker{input: <<"\n"::utf8, input::binary>>}, _, _, _),
    do: has_4_level_indented(input)

  def should_parse(_input, _, _, _), do: false

  defp has_4_level_indented(input) do
    String.graphemes(input)
    |> Enum.split_while(fn
      " " -> true
      "\t" -> true
      _ -> false
    end)
    |> elem(0)
    |> Enum.reduce(0, fn
      " ", acc -> acc + 1
      "\t", acc -> acc + 4
    end) > 3
  end

  defp indent_for(" "), do: 1
  defp indent_for("\t"), do: 4
end
