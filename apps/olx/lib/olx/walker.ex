defmodule Olx.Walker do

  defstruct [:input, :rest, line: 1, column: 1]

  @type t :: %__MODULE__{
    input: String.t(),
    rest: String.t(),
    line: integer(),
    column: integer()
  }

  @spec start(String.t())::__MODULE__.t()
  def start(input) do
    {input, rest} = String.split_at(input, 1)
    %__MODULE__{
      input: input,
      rest: rest
    }
  end

  @spec walk(__MODULE__.t())::__MODULE__.t()
  def walk(walker) do
    {next, rest} = String.split_at(walker.rest, 1)
    %__MODULE__{
      walker |
        input: walker.input <> next,
        rest: rest,
        line: walker.line + increment_line(next),
        column: walker.column + increment_column(next)
    }
  end

  @spec consume_input(__MODULE__.t())::__MODULE__.t()
  def consume_input(walker) do
    %__MODULE__{
      walker |
        input: "",
    }
  end

  defp increment_line("\n"), do: 1
  defp increment_line(_), do: 0
  defp increment_column("\n"), do: 0
  defp increment_column(_), do: 1

end
