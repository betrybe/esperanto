defmodule Esperanto.Parsers.Bold do
  @moduledoc """
  Create a choice tag with all content between ( ) and \n
  """

  defmodule BoldBarrier do
    use Esperanto.Barriers.RegexBarrier, delimiter: ~r/^\*\*/
  end

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^\*\*/,
    barrier: BoldBarrier,
    enclosing_tag: :strong
end
