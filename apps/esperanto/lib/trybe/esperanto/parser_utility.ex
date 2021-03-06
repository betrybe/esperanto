defmodule Esperanto.ParserUtility do
  @moduledoc """
  Utility used to match inputs
  """

  require Logger

  def find_sibiling(nil, _tree), do: nil

  def find_sibiling(parent, tree),
    do:
      parent
      |> NaryTree.children(tree)
      |> List.last()

  def ensure_has_matched(walker, delimiter) do
    if !match(walker.input, delimiter) do
      raise "Expected to find #{__MODULE__.delimiter_as_string(delimiter)} at line:#{walker.line},column:#{walker.column}. Found: #{walker.input}"
    end
  end

  def match(input, delimiter) when is_binary(delimiter),
    do: match(input, delimiter_as_regex(delimiter))

  def match(input, delimiter) do
    String.match?(input, delimiter)
  end

  def delimiter_as_regex(delimiter) when is_binary(delimiter),
    do: Regex.escape(delimiter) |> Regex.compile!()

  def delimiter_as_regex(delimiter), do: delimiter
  def delimiter_as_string(delimiter), do: Regex.source(delimiter_as_regex(delimiter))
end
