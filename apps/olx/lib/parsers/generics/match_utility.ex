defmodule Trybe.Esperanto.MatchUtility do
  require Logger

  def ensure_has_matched(walker, delimiter) do
    if !match(walker.input, delimiter) do
      raise "Expected to find #{MatchUtility.delimiter_as_str(delimiter)} at line:#{walker.line},column:#{
              walker.column
            }. Found: #{walker.input}"
    end
  end

  def match(input, delimiter) when is_binary(delimiter),
    do: match(input, delimiter_as_regex(delimiter))

  def match(input, delimiter) do
    hasMatched = String.match?(input, delimiter)

    if hasMatched do
      Logger.debug(
        "#{__MODULE__} has matched for \"#{input}\" with \"#{Regex.source(delimiter)}\""
      )
    end

    hasMatched
  end

  def delimiter_as_regex(delimiter) when is_binary(delimiter),
    do: Regex.escape(delimiter) |> Regex.compile!()

  def delimiter_as_regex(delimiter), do: delimiter
  def delimiter_as_string(delimiter), do: Regex.source(delimiter_as_regex(delimiter))
end
