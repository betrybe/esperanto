defmodule BarrierUtility do

  alias Esperanto.Walker

  @spec assert_walker_is_barried(Walker.t()) :: nil
  def assert_walker_is_barried(%Walker{rest: rest} = walker) do
    if !Walker.is_barried(walker) do
      raise "trying to destroy a barrier of an unbarrier Walker. This shouldn`t never happen"
    end
  end

end
