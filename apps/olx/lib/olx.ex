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
  @spec parse(String.t(), list())::ASTNode
  def parse(input, opts) do
    Problem.parse(input, nil, nil, opts)
  end
end
