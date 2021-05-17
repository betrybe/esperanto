defmodule Esperanto.Olx.Parsers.ChoiceHint do
  @moduledoc """
  Create a choice hint tag
  """

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^{{/,
    end_delimiter: ~r/^}}/,
    enclosing_tag: :choicehint
end
