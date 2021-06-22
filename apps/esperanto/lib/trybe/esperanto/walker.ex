defmodule Esperanto.Walker do
  @moduledoc """
  Walker is used to go through input couting line and columns.
  Every parser is responsible to walk and leave the walker in the state he can continue
  """

  alias Esperanto.Barriers.NeverMatchBarrier
  require Logger

  defstruct [:input, rest: "", line: 1, column: 1, barriers: [NeverMatchBarrier], barriered: ""]

  @type t :: %__MODULE__{
          input: String.t(),
          rest: String.t() | atom(),
          line: integer(),
          barriers: list(),
          barriered: String.t(),
          column: integer()
        }

  @doc ~S"""
  Start the walker by split it in input and rest

  ## Examples

      iex> Esperanto.Walker.start("abc")
      %Esperanto.Walker{input: "a", rest: "bc"}

      iex> Esperanto.Walker.start("")
      %Esperanto.Walker{input: "", rest: ""}

      iex> Esperanto.Walker.start("a")
      %Esperanto.Walker{input: "a", rest: ""}
  """
  @spec start(String.t()) :: __MODULE__.t()
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

      iex>
      Esperanto.Walker.start("abc") |> Esperanto.Walker.walk()
      %Esperanto.Walker{input: "ab", rest: "c", column: 2}

      iex> Esperanto.Walker.start("a\nc") |> Esperanto.Walker.walk()
      %Esperanto.Walker{input: "a\n", rest: "c", column: 1, line: 2}
  """
  @spec walk(__MODULE__.t()) :: __MODULE__.t()
  def walk(walker) do
    cond do
      is_barried(walker) ->
        walker

      List.first(walker.barriers).should_bar(walker) ->
        %__MODULE__{
          walker
          | rest: :barried,
            barriered: walker.rest
        }

      true ->
        do_walk(walker)
    end
  end

  def walk_until(walker, regex) do
    cond do
      String.match?(walker.input, regex) -> walker
      walker.rest == "" -> walker
      true -> walk_until(do_walk(walker), regex)
    end
  end

  @spec is_barried(__MODULE__.t()) :: boolean()
  def is_barried(walker), do: walker.rest == :barried

  @doc ~S"""
  Prevents walker from go fetch more content with the rest matches the barrier
  until the barrier is destroyed
  """
  @spec with_barrier(__MODULE__.t(), any()) :: __MODULE__.t()
  def with_barrier(walker, barrier) do
    Logger.debug("Creating barrier #{barrier}")

    %__MODULE__{
      walker
      | barriers: [barrier] ++ walker.barriers
    }
  end

  @spec destroy_barrier(__MODULE__.t()) :: __MODULE__.t()
  def destroy_barrier(walker) do
    barrier = List.first(walker.barriers)
    Logger.debug("Destroyng barrier #{barrier}")
    barrier.destroy_barrier(walker)
  end

  @doc ~S"""
  Consume the current walk input

  ## Examples

      iex> Esperanto.Walker.consume_input(Esperanto.Walker.start("abc"))
      %Esperanto.Walker{input: "", rest: "bc", column: 1}
  """
  @spec consume_input(__MODULE__.t(), length :: integer()) :: __MODULE__.t()
  def consume_input(walker, length \\ 0)

  def consume_input(walker, 0) do
    %__MODULE__{
      walker
      | input: ""
    }
  end

  def consume_input(walker, length) do
    case walker.rest do
      :barried ->
        %__MODULE__{
          walker
          | input: "",
            rest: String.slice(walker.input, length..-1) <> walker.barriered
        }

      _ ->
        %__MODULE__{
          walker
          | input: "",
            rest: String.slice(walker.input, length..-1) <> walker.rest
        }
    end
  end

  def consume_input_matching_regex(walker, regex) do
    lenght = String.length(strip_from_regex(walker.input, regex))
    consume_input(walker, lenght)
  end

  def strip_from_regex(input, regex) do
    Regex.scan(regex, input)
    |> List.flatten()
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> List.first()
  end

  defp do_walk(walker) do
    {next, rest} = String.split_at(walker.rest, 1)
    {line, column} = increment_line_and_column(next, walker.line, walker.column)

    %__MODULE__{
      walker
      | input: walker.input <> next,
        rest: rest,
        line: line,
        column: column
    }
  end

  def increment_line_and_column(<<input::utf8, rest::binary>>, line, column) do
    {line, column} = increment_line_and_column(input, line, column)
    increment_line_and_column(rest, line, column)
  end

  def increment_line_and_column(input, current_line, current_column) do
    line = increment_line([input])
    column = increment_column([input])

    if line != current_line do
      {line + current_line, 1 + column}
    else
      {line + current_line, current_column + column}
    end
  end

  defp increment_line('\n'), do: 1
  defp increment_line(_), do: 0
  defp increment_column('\n'), do: 1
  defp increment_column(_), do: 0
end
