defmodule Esperanto.Parsers.FencedCode do
  @moduledoc """
  Parse code indented with ```
  """
  alias Esperanto.CodeUtility
  alias Esperanto.Walker

  @behaviour Esperanto.Parser

  @impl Esperanto.Parser
  def parse(walker, tree, parent_id, _opts) do
    {walker, content} = get_content(walker)

    if content == "" do
      {tree, walker}
    else
      pre = NaryTree.Node.new(:pre)
      code = NaryTree.Node.new(:code, CodeUtility.escape(content))

      tree = NaryTree.add_child(tree, pre, parent_id)
      tree = NaryTree.add_child(tree, code, pre.id)

      {tree, walker}
    end
  end

  @impl Esperanto.Parser
  def should_parse(%Walker{input: "```"}, _, _, _), do: true
  def should_parse(_, _, _, _), do: false

  defp get_content(walker) do
    walker = CodeUtility.walk_until_not_back_slash(walker)
    backup_walker = walker
    back_slash_count = String.length(walker.input)

    walker = Walker.consume_input(walker)
    regex = Regex.compile!("[`]{#{back_slash_count}}$")

    walker = Walker.walk_until(walker, regex)

    if walker.rest == "" and !Regex.match?(regex, walker.input) do
      {backup_walker, ""}
    else
      {content, _} = String.split_at(walker.input, -back_slash_count)
      {Walker.consume_input(walker), content}
    end
  end
end
