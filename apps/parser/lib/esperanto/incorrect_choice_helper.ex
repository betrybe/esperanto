defmodule Esperanto.Parser.IncorectChoiceHelper do
  use Markright.Helpers.Lead, tag: :choice, lead_and_handler: {"( )", [Esperanto.Parser.IncorectChoiceHelper]}
end
