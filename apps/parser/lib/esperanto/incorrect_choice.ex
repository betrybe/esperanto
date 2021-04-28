defmodule Esperanto.Parser.IncorrectChoice do
  use Markright.Continuation
  @behaviour Markright.Parser

  def to_ast(input, %Plume{} = plume \\ %Plume{}) when is_binary(input) do
    IO.puts("Incorrect")
    IO.inspect(input)
    plume = Esperanto.Parser.IncorrectChoiceHelper.to_ast(input, plume)
    {:choice, attrs, ast} = plume.ast
    attrs = Map.put(attrs, :correct, false)
    plume = %Plume{plume | ast: {:choice, attrs, ast}}
    IO.puts("Incorrect")
    IO.inspect(plume.ast)
    plume
  end
end
