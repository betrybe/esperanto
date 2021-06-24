defmodule Esperanto.Olx.Parsers.Label do
  @moduledoc """
  Create a label tag
  """

  defmodule LabelBarrier do
    @moduledoc """
    Label delimited by `<<`
    """
    use Esperanto.Barriers.RegexBarrier, delimiter: ~r/^<</
  end

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^>>/,
    barrier: LabelBarrier,
    enclosing_tag: :label
end
