defmodule Olx.Parsers.EnclosingTag do
  alias Olx.Walker
  alias Olx.Parsers.TopLevel

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
      @behaviour Olx.Parser

      @start_delimiter unquote(start_delimiter)
      @end_delimiter unquote(end_delimiter)
      @tag unquote(tag)

      @impl Olx.Parser
      def parse(walker, tree, parent_id, opts) do
        if !match(walker.input, @start_delimiter) do
          delimiter_as_str = Regex.source(delimiter_as_regex(@start_delimiter))

          raise "Expected to find #{delimiter_as_str} at line:#{walker.line},column:#{
                  walker.column
                }. Found: #{walker.input}"
        end

        node = NaryTree.Node.new(@tag)
        tree = NaryTree.add_child(tree, node, parent_id)

        {tree, walker} =
          walker
          |> Walker.consume_input()
          |> Walker.with_barrier(@end_delimiter)
          |> TopLevel.parse(tree, node.id, opts)

        {tree, Walker.destroy_barrier(walker)}
      end

      @impl Olx.Parser
      def should_parse(%Walker{input: input}, _, _, opts) do
        match(input, @start_delimiter)
      end

      defp match(input, delimiter) when is_binary(delimiter),
        do: match(input, delimiter_as_regex(delimiter))

      defp match(input, delimiter) do
        hasMatched = String.match?(input, delimiter)

        if hasMatched do
          Logger.debug(
            "#{__MODULE__} has matched for \"#{input}\" with \"#{Regex.source(delimiter)}\""
          )
        end

        hasMatched
      end

      defp delimiter_as_regex(delimiter) when is_binary(delimiter),
        do: Regex.escape(delimiter) |> Regex.compile!()

      defp delimiter_as_regex(delimiter), do: delimiter
    end
  end
end
