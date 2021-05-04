defmodule Trybe.Esperanto.Parsers.Br do
  use Trybe.Esperanto.Parsers.Generics.EmptyTag,
    delimiter: ~r/^\ \ \n/,
    tag: :br
end
