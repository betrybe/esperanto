defmodule Olx do
  alias Olx.Parsers.Problem
  alias Olx.ASTNode
  @moduledoc """
  Documentation for `Olx`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Olx.hello()
      :world

  """
  def parse(input, opts) do
    Problem.parse(input, opts)
  end
end
