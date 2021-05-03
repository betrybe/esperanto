defmodule Olx.Parsers.Label do
  use Olx.Parsers.EnclosingTag,
    start_delimiter: ~r/^>>/,
    end_delimiter: ~r/^<</,
    enclosing_tag: "label"
end

defmodule Olx.Parsers.Choice do
  use Olx.Parsers.EnclosingTag,
    start_delimiter: ~r/\(\ \)/,
    end_delimiter: ~r/^\n/,
    enclosing_tag: "choice"
end
