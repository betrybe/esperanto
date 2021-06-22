defmodule Esperanto.Olx.Parsers.IncorrectChoice do
  @moduledoc """
  Create a choice tag with all content between ( ) and \n
  """

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^\(\ \)/,
    barrier: Esperanto.Barriers.NewLineBarrier,
    enclosing_tag: :choice,
    attrs: %{:correct => false},
    surrounding_tag: :choicegroup,
    surrounding_attrs: %{:type => "MultipleChoice"}
end

defmodule Esperanto.Olx.Parsers.CorrectChoice do
  @moduledoc """
  Create a choice tag with all content between (x) and \n
  """

  use Esperanto.Parsers.Generics.EnclosingTag,
    start_delimiter: ~r/^\(x\)/,
    barrier: Esperanto.Barriers.NewLineBarrier,
    enclosing_tag: :choice,
    attrs: %{:correct => true},
    surrounding_tag: :choicegroup,
    surrounding_attrs: %{:type => "MultipleChoice"}
end
