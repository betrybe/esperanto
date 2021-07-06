defmodule Esperanto.Parsers.FencedCode do
  @moduledoc """
  Parse code indented with ```
  """
  alias Esperanto.CodeUtility
  alias Esperanto.Walker

  @behaviour Esperanto.Parser

  @impl Esperanto.Parser
  def parse(walker, tree, parent_id, _opts) do
    walker_and_tag = get_code_tag(walker)
    astify(walker_and_tag, tree, parent_id)
  end

  defp astify({walker, ""}, tree, _parent_id), do: {tree, walker}
  defp astify({walker, tag}, tree, parent_id) do
    pre = NaryTree.Node.new(:pre)
    code = NaryTree.Node.new(:code, tag)

    tree = NaryTree.add_child(tree, pre, parent_id)
    tree = NaryTree.add_child(tree, code, pre.id)

    {tree, walker}
  end

  @impl Esperanto.Parser
  def should_parse(%Walker{input: "```"}, _, _, _), do: true
  def should_parse(_, _, _, _), do: false

  defp get_code_tag(walker) do
    walker = CodeUtility.walk_until_not_back_slash(walker)
    backup_walker = walker
    back_slash_count = String.length(walker.input)
    walker = Walker.consume_input(walker)

    {language, walker} = get_language(walker)

    regex = Regex.compile!("[`]{#{back_slash_count}}$")
    walker = Walker.walk_until(walker, regex)

    if walker.rest == "" and !Regex.match?(regex, walker.input) do
      {backup_walker, ""}
    else
      {content, _} = String.split_at(walker.input, -back_slash_count)
      {Walker.consume_input(walker), get_code_tag(content, language)}
    end
  end

  defp get_code_tag(content, ""), do: CodeUtility.escape(content)

  defp get_code_tag(content, language),
    do: {CodeUtility.escape(content), %{"class" => "language-#{language}"}}

  defp get_language(walker) do
    walker = Walker.walk_until(walker, ~r/\n$/)
    {String.trim(walker.input), Walker.consume_input(walker)}
  end
end
