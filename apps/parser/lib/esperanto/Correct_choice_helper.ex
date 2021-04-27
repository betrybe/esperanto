defmodule Esperanto.Parser.CorrectChoiceHelper do
  use Markright.Helpers.Lead, tag: :choice, lead_and_handler: {"(x)", [Esperanto.Parser.CorrectChoiceHelper]}
end
