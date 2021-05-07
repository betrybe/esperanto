defmodule Esperanto.Parsers.Link do
  @moduledoc """
  Parser a link in the format [link text](http.example.com)
  """
  alias Esperanto.Walker
  alias Esperanto.MatchUtility
  @behaviour Esperanto.Parser
  @markdown_link_regex ~r/^\[(?<content>.*)\]\((?<href>.*?)\)/

  @impl Esperanto.Parser
  def parse(walker, tree, parent_id, _opts) do
    MatchUtility.ensure_has_matched(walker, @markdown_link_regex)
    captures = Regex.named_captures(@markdown_link_regex, walker.input)
    content = {captures["content"], %{:href => captures["href"]}}
    node = NaryTree.Node.new("a", content)
    tree = NaryTree.add_child(tree, node, parent_id)

    {tree, Walker.consume_input(walker)}
  end

  @impl Esperanto.Parser
  def should_parse(%Walker{input: input}, _, _, _),
    do: MatchUtility.match(input, @markdown_link_regex)
end
