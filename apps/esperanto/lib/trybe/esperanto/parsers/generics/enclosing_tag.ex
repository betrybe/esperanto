defmodule Esperanto.Parsers.Generics.EnclosingTag do
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.ParserUtility
  alias Esperanto.Walker

  @doc """
  opts
    * :start_delimiter
    * :barrier
    * :enclosing_tag
    * :attrs
  """

  @moduledoc """
  Simple enclose the contents between `:start_delimiter` and `:barrier`
  with the `enclosing_tag` and `attrs` specified
  It's possible to surround all siblings together with the `surround` tag if specified
  """

  defmacro __using__(options) do
    start_delimiter = Keyword.get(options, :start_delimiter)
    barrier = Keyword.get(options, :barrier)
    tag = Keyword.get(options, :enclosing_tag)
    surrounding_tag = Keyword.get(options, :surrounding_tag, nil)

    create_node_bloc =
      if surrounding_tag do
        quote do
          parent = NaryTree.get(tree, parent_id)

          tree =
            case find_surrounding(parent, tree) do
              nil ->
                surrounding = NaryTree.Node.new(@surrounding_tag, {:empty, @surrounding_attrs})

                tree
                |> NaryTree.add_child(surrounding, parent_id)
                |> NaryTree.add_child(node, surrounding.id)

              surrounding ->
                NaryTree.add_child(tree, node, surrounding.id)
            end
        end
      else
        quote do
          tree = NaryTree.add_child(tree, node, parent_id)
        end
      end

    quote do
      require Logger
      @behaviour Esperanto.Parser

      @start_delimiter unquote(start_delimiter)
      @barrier unquote(barrier)
      @tag unquote(tag)
      @surrounding_tag unquote(surrounding_tag)
      @attrs Keyword.get(unquote(options), :attrs, %{})
      @surrounding_attrs Keyword.get(unquote(options), :surrounding_attrs, %{})

      @impl Esperanto.Parser
      def parse(walker, tree, parent_id, opts) do
        ParserUtility.ensure_has_matched(walker, @start_delimiter)
        node = NaryTree.Node.new(@tag, {:empty, @attrs})

        unquote(create_node_bloc)

        {tree, walker} =
          walker
          |> Walker.consume_input_matching_regex(@start_delimiter)
          |> Walker.with_barrier(@barrier)
          |> TopLevel.parse(tree, node.id, opts)

        {tree, Walker.destroy_barrier(walker)}
      end

      @impl Esperanto.Parser
      def should_parse(%Walker{input: input}, _, _, opts) do
        ParserUtility.match(input, @start_delimiter)
      end

      defp find_surrounding(parent, tree),
        do:
          ParserUtility.find_sibiling(parent, tree)
          |> find_surrounding(tree, parent.id)

      # node is arealdy surrounded with the desire tag
      defp find_surrounding(
             %NaryTree.Node{name: @surrounding_tag, content: {:empty, _attrs}} = surrouding,
             tree,
             _parent_id
           ) do
        surrouding
      end

      defp find_surrounding(
             _sibiling,
             _tree,
             _parent_id
           ) do
        nil
      end
    end
  end
end
