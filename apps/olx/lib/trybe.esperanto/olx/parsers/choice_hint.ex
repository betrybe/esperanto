defmodule Esperanto.Olx.Parsers.ChoiceHint do
  @moduledoc """
  Create a choice hint tag
  """

  defmodule ChoiceHintBarrier do
    @moduledoc """
    Choicehint delimited by `}}`
    """
    use Esperanto.Barriers.RegexBarrier, delimiter: ~r/^}}/
  end

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^{{/,
    barrier: ChoiceHintBarrier,
    enclosing_tag: :choicehint
end
