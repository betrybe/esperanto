defmodule Esperanto.Barrier do
  alias Esperanto.Walker

  @moduledoc """
  An interface responsible to stop the walker
  and also return a new walker with the barrier desotroyed
  """

  @doc """
  Check if parser should barrier the walker
  paremters:
    * `walker`- Parse is responsible to walk trough input
  returns: true if the the walker should be barried`
  """
  @callback should_bar(walker :: Walker.t()) :: boolean()

  @doc """
  Remove the barrier from the walker
  paremters:
    * `walker`- Parse is responsible to walk trough input
  returns: A new walker without the barrier`
  """
  @callback destroy_barrier(walker :: Walker.t()) :: Walker.t()
end
