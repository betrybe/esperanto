defmodule Esperanto.Parsers.Img do
  alias Esperanto.Walker
  alias Esperanto.MatchUtility
  @behaviour Esperanto.Parser
  @markdown_img_regex ~r/^!\[(?<alt>.*)\]\((?<src>.*?)\)/

  @impl Esperanto.Parser
  @spec parse(Esperanto.Walker.t(), any, any, any) :: {any, Esperanto.Walker.t()}
  def parse(%Walker{input: ""} = walker, tree, _parent_id, _opts) do
    {tree, walker}
  end

  @impl Esperanto.Parser
  def parse(walker, tree, parent_id, _opts) do
    MatchUtility.ensure_has_matched(walker, @markdown_img_regex)
    captures = Regex.named_captures(@markdown_img_regex, walker.input)
    content = { :empty, %{ :alt => captures["alt"], :src => captures["src"] }}
    node = NaryTree.Node.new("img", content)
    tree = NaryTree.add_child(tree, node, parent_id)

    {tree, Walker.consume_input(walker)}
  end


  @impl Esperanto.Parser
  def should_parse(%Walker{input: input}, _, _, _), do: MatchUtility.match(input, @markdown_img_regex)
end
