defmodule Esperanto.Parsers.InlineFencedCode do
  @moduledoc """
  Parse an idented code with 4 space or tab
  """
  alias Esperanto.Walker

  @behaviour Esperanto.Parser
  @max_inline_back_slash 2

  @impl Esperanto.Parser
  def parse(walker, tree, parent_id, _opts) do
    {walker, content} = get_content(walker)

    if content == "" do
      {tree, walker}
    else
      code = NaryTree.Node.new(:code, content)
      tree = NaryTree.add_child(tree, code, parent_id)
      {tree, walker}
    end
  end

  @impl Esperanto.Parser
  def should_parse(%Walker{input: "`"}, _, _, _), do: true
  def should_parse(_, _, _, _), do: false

  defp get_content(walker) do
    walker = walk_until_not_back_slash(walker)
    backup_walker = walker
    back_slash_count = String.length(walker.input)

    if back_slash_count > @max_inline_back_slash do
      {walker, ""}
    else
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

  defp walk_until_not_back_slash(walker) do
    if String.starts_with?(walker.rest, "`") do
      walker
      |> Walker.walk()
      |> walk_until_not_back_slash()
    else
      walker
    end
  end
end
