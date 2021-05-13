defmodule Esperanto.Parsers.Br do
  @moduledoc """
  Create a <br /> for each "  \\n"
  """

  use Esperanto.Parsers.Generics.EmptyTag,
    delimiter: ~r/^\ \ \n/,
    tag: :br
end
