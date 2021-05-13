defmodule Esperanto.Parsers.Generics.EnclosingTag do
  alias Esperanto.MatchUtility
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  @doc """
  opts
    * :start_delimiter
    * :end_delimiter
    * :enclosing_tag
  """

  @moduledoc """
  Simple enclose the contents between `:start_delimiter` and :`end_delimiter` with the `enclosing_tag`
  """

  defmacro __using__(opts) do
    start_delimiter = Keyword.get(opts, :start_delimiter)
    end_delimiter = Keyword.get(opts, :end_delimiter)
    tag = Keyword.get(opts, :enclosing_tag)

    quote do
      require Logger
      @behaviour Esperanto.Parser

      @start_delimiter unquote(start_delimiter)
      @end_delimiter unquote(end_delimiter)
      @tag unquote(tag)

      @impl Esperanto.Parser
      def parse(walker, tree, parent_id, opts) do
        MatchUtility.ensure_has_matched(walker, @start_delimiter)

        node = NaryTree.Node.new(@tag)
        tree = NaryTree.add_child(tree, node, parent_id)

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
    end
  end
end
