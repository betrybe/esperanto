defmodule TreeUtility do
  require Logger

  def log_tree(
        %NaryTree{} = tree,
        func \\ fn x -> "#{x.name}:#{x.content}" end,
        log_level \\ :debug
      ) do
    do_log_tree(%NaryTree.Node{} = tree.nodes[tree.root], tree.nodes, func, log_level)
  end

  defp do_log_tree(node, _, _, _) when is_nil(node),
    do: raise("Expecting %NaryTree.Node(), found nil.")

  defp do_log_tree(%NaryTree.Node{children: children} = node, _nodes, func, log_level)
       when children == [] do
    Logger.log(log_level, indent(node.level) <> "- " <> func.(node))
  end

  defp do_log_tree(%NaryTree.Node{children: children} = node, nodes, func, log_level) do
    Logger.log(log_level, indent(node.level) <> "* " <> func.(node))

    Enum.each(children, fn child_id ->
      do_log_tree(nodes[child_id], nodes, func, log_level)
    end)
  end

  defp indent(n, c \\ " ") do
    String.duplicate(c, n * 2)
  end
end
