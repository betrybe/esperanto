defmodule Esperanto.Parsers.Generics.EmptyTag do
  alias Esperanto.MatchUtility
  alias Esperanto.Walker

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
      @behaviour Esperanto.Parser

      @delimiter unquote(delimiter)
      @tag unquote(tag)

      @impl Esperanto.Parser
      def parse(walker, tree, parent_id, _opts) do
        MatchUtility.ensure_has_matched(walker, @delimiter)

        node = NaryTree.Node.new(@tag)
        tree = NaryTree.add_child(tree, node, parent_id)

        {tree, Walker.consume_input(walker)}
      end

      @impl Esperanto.Parser
      def should_parse(%Walker{input: input}, _, _, opts) do
        MatchUtility.match(input, @delimiter)
      end
    end
  end
end
