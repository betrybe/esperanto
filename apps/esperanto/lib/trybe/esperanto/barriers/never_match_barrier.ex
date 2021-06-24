defmodule Esperanto.Barriers.NeverMatchBarrier do
  @moduledoc """
  An barrier that never bar anything
  """
  @behaviour Esperanto.Barrier

  def should_bar(_), do: false
  def destroy_barrier(walker), do: walker
end
