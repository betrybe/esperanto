defmodule Esperanto.Parsers.Generics.EnclosingTag do
  alias Esperanto.MatchUtility
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  @doc """
  opts
    * :start_delimiter
    * :end_delimiter
    * :enclosing_tag
    * :attrs
  """

  @moduledoc """
  Simple enclose the contents between `:start_delimiter` and :`end_delimiter`
  with the `enclosing_tag` and `attrs` specified
  It's possible to surround all siblings together with the `surround` tag if specified
  """

  defmacro __using__(options) do
    start_delimiter = Keyword.get(options, :start_delimiter)
    end_delimiter = Keyword.get(options, :end_delimiter)
    tag = Keyword.get(options, :enclosing_tag)
    surrounding_tag = Keyword.get(options, :surrounding_tag, nil)

    quote do
      require Logger
      @behaviour Esperanto.Parser

      @start_delimiter unquote(start_delimiter)
      @end_delimiter unquote(end_delimiter)
      @tag unquote(tag)
      @surrounding_tag unquote(surrounding_tag)
      @attrs Keyword.get(unquote(options), :attrs, %{})
      @surrounding_attrs Keyword.get(unquote(options), :surrounding_attrs, %{})

      @impl Esperanto.Parser
      def parse(walker, tree, parent_id, opts) do
        MatchUtility.ensure_has_matched(walker, @start_delimiter)
        node = NaryTree.Node.new(@tag, {:empty, @attrs})

        # // TODO provavelmente existe um jeito mais elegante de resolver isso
        # // Com with talvez?
        tree =
          case @surrounding_tag do
            nil ->
              NaryTree.add_child(tree, node, parent_id)

            _ ->
              parent = NaryTree.get(tree, parent_id)

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

        {tree, walker} =
          walker
          |> Walker.consume_input()
          |> Walker.with_barrier(@end_delimiter)
          |> TopLevel.parse(tree, node.id, opts)

        {tree, Walker.destroy_barrier(walker)}
      end

      @impl Esperanto.Parser
      def should_parse(%Walker{input: input}, _, _, opts) do
        MatchUtility.match(input, @start_delimiter)
      end

      defp find_surrounding(parent, tree),
        do:
          parent
          |> NaryTree.children(tree)
          |> List.last()
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
             tree,
             parent_id
           ) do
        nil
      end
    end
  end
end
