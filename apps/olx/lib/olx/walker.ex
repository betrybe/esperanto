defmodule Olx.Walker do

  defstruct [:input, :rest, line: 1, column: 1]

  @type t :: %__MODULE__{
    input: String.t(),
    rest: String.t(),
    line: integer(),
    column: integer()
  }

  @doc ~S"""
  Start the walker by split it in input and rest

  ## Examples

      iex> Olx.Walker.start("abc")
      %Olx.Walker{input: "a", rest: "bc"}

      iex> Olx.Walker.start("")
      %Olx.Walker{input: "", rest: ""}

      iex> Olx.Walker.start("a")
      %Olx.Walker{input: "a", rest: ""}
  """
  @spec start(String.t())::__MODULE__.t()
  def start(input) do
    {input, rest} = String.split_at(input, 1)
    %__MODULE__{
      input: input,
      rest: rest
    }
  end

  @doc ~S"""
  Walk through next input

  ## Examples

      iex> Olx.Walker.walk(Olx.Walker.start("abc"))
      %Olx.Walker{input: "ab", rest: "c", column: 2}

      iex> Olx.Walker.walk(Olx.Walker.start("a\nc"))
      %Olx.Walker{input: "a\n", rest: "c", column: 1, line: 2}
  """
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

  @doc ~S"""
  Consume the current walk input

  ## Examples

      iex> Olx.Walker.consume_input(Olx.Walker.start("abc"))
      %Olx.Walker{input: "", rest: "bc", column: 1}
  """
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
