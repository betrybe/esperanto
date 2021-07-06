defmodule Esperanto.Barriers.NewLineBarrier do
  @moduledoc """
  Barrie an walker by ignoring `  \n`
  """
  alias Esperanto.Walker
  @behaviour Esperanto.Barrier

  def should_bar(%Walker{input: input, rest: rest}) do
    input != "  " and String.match?(rest, ~r/^\n/)
  end

  def destroy_barrier(walker) do
    BarrierUtility.assert_walker_is_barried(walker)
    barried_content = Walker.strip_from_regex(walker.barriered, ~r/^\n/)

    {line, column} = Walker.increment_line_and_column(barried_content, walker.line, walker.column)
    rest = String.replace(walker.barriered, ~r/^\n/, "", global: false)

    {_, new_barriers} = List.pop_at(walker.barriers, 0)

    %Walker{
      walker
      | barriers: new_barriers,
        rest: rest,
        barriered: "",
        line: line,
        column: column
    }
  end
end
