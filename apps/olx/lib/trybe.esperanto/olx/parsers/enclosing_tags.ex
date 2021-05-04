defmodule Trybe.Esperanto.Olx.Parsers.Label do
  use Trybe.Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^>>/,
    end_delimiter: ~r/^<</,
    enclosing_tag: :label
end

defmodule Trybe.Esperanto.Olx.Parsers.Choice do
  use Trybe.Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/\(\ \)/,
    end_delimiter: ~r/^\n/,
    enclosing_tag: :choice
end
