defmodule Esperanto.Parsers.YamlMetadata do
  @moduledoc """
  Parse yaml metadata
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
  def should_parse(%Walker{input: "---", line: 1, column: 3}, _, _, _), do: true
  def should_parse(_, _, _, _), do: false

  defp get_code_tag(walker) do
    backup_walker = walker

    walker = Walker.consume_input(walker)

    regex = Regex.compile!("---$")

    walker = Walker.walk_until(walker, regex)

    # TODO Actually handle the yaml metadata
  end

end
