defmodule Esperanto.Parsers.Italic do
  @moduledoc """
  Create a choice tag with all content between ( ) and \n
  """

  defmodule ItalicBarrier do
    @moduledoc """
    Italic delimited by `*`
    """
    use Esperanto.Barriers.RegexBarrier, delimiter: ~r/^\*(?=[^\*])/
  end

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^\*(?=[^\*])/,
    barrier: ItalicBarrier,
    enclosing_tag: :em
end
