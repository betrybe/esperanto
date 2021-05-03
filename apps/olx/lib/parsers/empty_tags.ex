defmodule Olx.Parsers.Br do
  use Trybe.Esperanto.EmptyTag,
    delimiter: ~r/^\ \ \n/,
    tag: :br
end
