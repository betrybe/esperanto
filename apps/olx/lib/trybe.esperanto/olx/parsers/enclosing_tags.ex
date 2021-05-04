defmodule Esperanto.Olx.Parsers.Label do
  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^>>/,
    end_delimiter: ~r/^<</,
    enclosing_tag: :label
end

defmodule Esperanto.Olx.Parsers.Choice do
  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/\(\ \)/,
    end_delimiter: ~r/^\n/,
    enclosing_tag: :choice
end
