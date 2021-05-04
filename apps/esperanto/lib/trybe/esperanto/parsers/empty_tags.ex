defmodule Esperanto.Parsers.Br do
  use Esperanto.Parsers.Generics.EmptyTag,
    delimiter: ~r/^\ \ \n/,
    tag: :br
end
