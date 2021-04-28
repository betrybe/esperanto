defmodule Esperanto.Parser.IncorrectChoiceHelper do
  use Markright.Helpers.Lead,
    tag: :choice,
    lead_and_handler: {"( )", [Esperanto.Parser.IncorrectChoiceHelper]}
end
