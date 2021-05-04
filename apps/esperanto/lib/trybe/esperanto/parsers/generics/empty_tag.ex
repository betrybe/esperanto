defmodule Trybe.Esperanto.Parsers.Generics.EmptyTag do
  alias Trybe.Esperanto.Walker
  alias Trybe.Esperanto.MatchUtility

  @spec __using__(keyword) ::
          {:__block__, [],
           [{:@, [...], [...]} | {:def, [...], [...]} | {:require, [...], [...]}, ...]}
  @doc """
  opts
    * :delimiter
    * :tag
  """

  @moduledoc """
  replace the :delimiter with an an empty :tag
  """

  defmacro __using__(opts) do
    delimiter = Keyword.get(opts, :delimiter)
    tag = Keyword.get(opts, :tag)

    quote do
      require Logger
      @behaviour Trybe.Esperanto.Parser

      @delimiter unquote(delimiter)
      @tag unquote(tag)

      @impl Trybe.Esperanto.Parser
      def parse(walker, tree, parent_id, opts) do
        MatchUtility.ensure_has_matched(walker, @delimiter)

        node = NaryTree.Node.new(@tag)
        tree = NaryTree.add_child(tree, node, parent_id)

        {tree, Walker.consume_input(walker)}
      end

      @impl Trybe.Esperanto.Parser
      def should_parse(%Walker{input: input}, _, _, opts) do
        MatchUtility.match(input, @delimiter)
      end
    end
  end
end