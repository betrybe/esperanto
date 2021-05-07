defmodule Esperanto.Olx.Parsers.Label do

  @moduledoc """
  Create a label tag
  """

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^>>/,
    end_delimiter: ~r/^<</,
    enclosing_tag: :label
end
