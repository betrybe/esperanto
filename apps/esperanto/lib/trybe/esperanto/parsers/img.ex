defmodule Esperanto.Parsers.Img do
  @moduledoc """
  Parse an image with the format ![alt](http://image.url)
  """

  alias Esperanto.ParserUtility
  alias Esperanto.Walker

  @behaviour Esperanto.Parser
  @markdown_img_regex ~r/^!\[(?<alt>.*)\]\((?<src>.*?)\)/

  @impl Esperanto.Parser
  def parse(walker, tree, parent_id, _opts) do
    ParserUtility.ensure_has_matched(walker, @markdown_img_regex)
    captures = Regex.named_captures(@markdown_img_regex, walker.input)
    content = {:empty, %{:alt => captures["alt"], :src => captures["src"]}}
    node = NaryTree.Node.new("img", content)
    tree = NaryTree.add_child(tree, node, parent_id)

    {tree, Walker.consume_input(walker)}
  end

  @impl Esperanto.Parser
  def should_parse(%Walker{input: input}, _, _, _),
    do: ParserUtility.match(input, @markdown_img_regex)
end
