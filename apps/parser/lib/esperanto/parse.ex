defmodule Esperanto.Parse do

  @moduledoc """
  Documentation for `Esperanto.Parse`.
  """


  @spec to_ast(String.t()) :: any()
  def to_ast(input) do
    Markright.to_ast(input, &custom_syntax/1)
  end

  def custom_syntax(%Markright.Continuation{ast: {:blockquote, _attrs, _ast}} = cont) do
    Esperanto.Parse.Label.astify(cont)
  end
  def custom_syntax(%Markright.Continuation{ast: {:article, %{}, ast}} = cont) do
    %Markright.Continuation{cont | ast: {:problem, %{}, ast}}
  end
  def custom_syntax(cont) do
    cont
  end
end
