defmodule Esperanto.Barriers.RegexBarrier do
  @moduledoc """
  Barrie an walker by the given `:delimiter` regex
  """
  alias Esperanto.Walker

  defmacro __using__(options) do
    barrier = Keyword.get(options, :delimiter)

    quote do
      @behaviour Esperanto.Barrier

      @barrier unquote(barrier)

      def should_bar(%Walker{} = walker) do
        String.match?(walker.rest, @barrier)
      end

      def destroy_barrier(%Walker{} = walker) do
        BarrierUtility.assert_walker_is_barried(walker)

        barried_content = Walker.strip_from_regex(walker.barriered, @barrier)

        {line, column} =
          Walker.increment_line_and_column(barried_content, walker.line, walker.column)

        rest = String.replace(walker.barriered, @barrier, "", global: false)

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
  end
end
