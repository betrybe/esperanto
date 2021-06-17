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
  Check if parser should handle current walker input
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

  @doc """
  Enchant parser returning a new tree
  paremters:
    * `tree`- Current AST tree
    * `tree`- the node being created
    * `parent_id`- id of the parent node
  returns: a new enchanted tree
  """
  @callback enchant_parser(tree(), NaryTree.Node.t(), integer()) :: tree()
  @optional_callbacks enchant_parser: 3

  def to_xml(tree, opts \\ []) do
    opts = Keyword.merge(opts, format: :none)
    tree
    |> NaryTree.to_map()
    |> do_to_xml()
    |> XmlBuilder.generate(opts)
  end

  @spec do_to_xml(nil | maybe_improper_list | map) :: {any, any, [...]}

  defp do_to_xml(tree_map) do
    children =
      case tree_map[:children] do
        nil ->
          []

        :empty ->
          []

        children ->
          Enum.map(children, fn
            child -> do_to_xml(child)
          end)
      end

    {content, attrs} = get_content_and_attr(tree_map[:content])
    tag = tree_map[:name]

    case tag do
      :empty ->
        children

      :p ->
        case String.trim(content) do
          "" -> children
          content -> {tag, attrs, [content] ++ children}
        end

      _ ->
        {tag, attrs, [content] ++ children}
    end
  end

  defp get_content_and_attr({:empty, attrs}), do: {"", attrs}
  defp get_content_and_attr({content, attrs}), do: {content, attrs}
  defp get_content_and_attr(:empty), do: {"", %{}}
  defp get_content_and_attr(content), do: {content, %{}}
end
