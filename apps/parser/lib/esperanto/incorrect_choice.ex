defmodule Esperanto.Parser.IncorrectChoice do
  use Markright.Continuation
  @behaviour Markright.Parser

  def to_ast(input, %Plume{} = plume \\ %Plume{}) when is_binary(input) do
    plume = Esperanto.Parser.IncorrectChoiceHelper.to_ast(input, plume)
    {:choice, attrs, ast} = plume.ast
    attrs = Map.put(attrs, :correct, false)
    %Plume{plume | ast: {:choice, attrs, ast} }
  end


end
