defmodule Esperanto.Parsers.Italic do
  @moduledoc """
  Create a choice tag with all content between ( ) and \n
  """

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^\*(?=[^\*])/,
    end_delimiter: ~r/^\*(?=[^\*])/,
    enclosing_tag: :em
end
