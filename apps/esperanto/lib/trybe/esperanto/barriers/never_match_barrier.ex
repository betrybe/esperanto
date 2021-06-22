defmodule Esperanto.Barriers.NeverMatchBarrier do
  @behaviour Esperanto.Barrier

  def should_bar(_), do: false
  def destroy_barrier(walker), do: walker
end
