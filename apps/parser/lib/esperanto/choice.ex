defmodule Esperanto.Parser.Choice do
  use Markright.Continuation
  @behaviour Markright.Parser

  def to_ast(input, %Plume{} = plume \\ %Plume{}) when is_binary(input) do
    IO.puts("Correct")
    IO.inspect(input)
    plume = Esperanto.Parser.CorrectChoiceHelper.to_ast(input, plume)
    {:choice, attrs, ast} = plume.ast
    attrs = Map.put(attrs, :correct, true)
    plume = %Plume{plume | ast: {:choice, attrs, ast}}
    IO.puts("Correct")
    IO.inspect(plume)
    plume
  end
end
