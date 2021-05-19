defmodule Esperanto.CodeUtility do
  @moduledoc """
  Utilities functions to parse code
  """

  alias Esperanto.Walker

  def walk_until_not_back_slash(walker) do
    if String.starts_with?(walker.rest, "`") do
      walker
      |> Walker.walk()
      |> walk_until_not_back_slash()
    else
      walker
    end
  end
end
