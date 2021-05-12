defmodule Esperanto.Parser do
  @moduledoc """
  Parser interface
  """
  alias Esperanto.Walker
  @type tree() :: any()

  @doc """
  Parse given input
  paremters:
    * `walker`- Parse is responsible to walk trough input
    * `tree`- Current AST tree
    * `parent_id`- id of the parent node
    * `opts`- id of the parent node
  returns: A tuple with the new tree and new walker
  """
  @callback parse(walker :: Walker.t(), tree :: tree(), parent_id :: integer(), opts :: keyword()) ::
              {tree(), Walker.t()}
  @doc """
  Parse given input
  paremters:
    * `walker`- Parse is responsible to walk trough input
    * `tree`- Current AST tree
    * `parent_id`- id of the parent node
    * `opts`- id of the parent node
  returns: true if the the parse should be used. Note that if two parsers returns true an `AmbigousSyntaxError` is raised
  """
  @callback should_parse(
              walker :: Walker.t(),
              tree :: tree(),
              parent_id :: integer(),
              opts :: keyword()
            ) :: boolean()

  def to_xml(tree) do
    map = NaryTree.to_map(tree)
    ast = do_to_xml(map)
    XmlBuilder.generate(ast, format: :none)
  end

  @spec do_to_xml(nil | maybe_improper_list | map) :: {any, any, [...]}
  defp do_to_xml(treeMap) do
    children =
      case treeMap[:children] do
        nil ->
          []

        :empty ->
          []

        children ->
          Enum.map(children, fn
            child -> do_to_xml(child)
          end)
      end

    {content, attrs} = get_content_and_attr(treeMap[:content])
    tag = treeMap[:name]

    case tag do
      :empty -> children
      _ -> {tag, attrs, [content] ++ children}
    end
  end

  defp get_content_and_attr({:empty, attrs}), do: {"", attrs}
  defp get_content_and_attr({content, attrs}), do: {content, attrs}
  defp get_content_and_attr(:empty), do: {"", %{}}
  defp get_content_and_attr(content), do: {content, %{}}
end
