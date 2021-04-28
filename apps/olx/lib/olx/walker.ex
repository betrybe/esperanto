defmodule Olx.Walker do
  defstruct [:input, :rest, line: 1, column: 1, barrier: ~r"$a", barriered: ""]

  @type t :: %__MODULE__{
          input: String.t(),
          rest: String.t() | atom(),
          line: integer(),
          barrier: Regex.t(),
          barriered: String.t(),
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
      Olx.Walker.start("abc") |> Olx.Walker.walk()
      %Olx.Walker{input: "ab", rest: "c", column: 2}

      iex> Olx.Walker.start("a\nc") |> Olx.Walker.walk()
      %Olx.Walker{input: "a\n", rest: "c", column: 1, line: 2}

      iex> Olx.Walker.start("a\nc")
      ...> |> Olx.Walker.with_barrier("\n")
      ...> |> Olx.Walker.walk()
      %Olx.Walker{barrier: ~r/\n/, barriered: "\nc", column: 1, input: "a", line: 1, rest: :barried}

      iex> Olx.Walker.start("a\nc")
      ...> |> Olx.Walker.with_barrier("\n")
      ...> |> Olx.Walker.walk()
      ...> |> Olx.Walker.walk()
      ...> |> Olx.Walker.walk()
      ...> |> Olx.Walker.walk()
      %Olx.Walker{barrier: ~r/\n/, barriered: "\nc", column: 1, input: "a", line: 1, rest: :barried}


      iex> Olx.Walker.start("a\nc")
      ...> |> Olx.Walker.with_barrier("\n")
      ...> |> Olx.Walker.walk()
      %Olx.Walker{barrier: ~r/\n/, barriered: "\nc", column: 1, input: "a", line: 1, rest: :barried}

      iex> Olx.Walker.start("a\nc")
      ...> |> Olx.Walker.with_barrier("\n")
      ...> |> Olx.Walker.destroy_barrier()
      ** (RuntimeError) trying to destroy a barrier of an unbarrier Walker. This shouldn`t never happen

      iex> Olx.Walker.start("a\nc")
      ...> |> Olx.Walker.with_barrier("\n")
      ...> |> Olx.Walker.walk()
      ...> |> Olx.Walker.destroy_barrier()
      ...> |> Olx.Walker.walk()
      %Olx.Walker{input: "a\n", rest: "c", column: 1, line: 2}

  """
  @spec walk(__MODULE__.t()) :: __MODULE__.t()
  def walk(walker) do
    cond do
      is_barried(walker) ->
        walker

      String.match?(walker.rest, walker.barrier) ->
        %__MODULE__{
          walker
          | rest: :barried,
            barriered: walker.rest
        }

      true ->
        {next, rest} = String.split_at(walker.rest, 1)

        %__MODULE__{
          walker
          | input: walker.input <> next,
            rest: rest,
            line: walker.line + increment_line(next),
            column: walker.column + increment_column(next)
        }
    end
  end

  @spec is_barried(__MODULE__.t()) :: boolean()
  def is_barried(walker), do: walker.rest == :barried

  @doc ~S"""
  Prevents walker from go fetch more content with the rest matches the barrier
  until the barrier is destroyed
  """
  @spec with_barrier(__MODULE__.t(), String.t() | Regex.t()) :: __MODULE__.t()
  def with_barrier(walker, %Regex{} = barrier) do
    %__MODULE__{
      walker
      | barrier: barrier
    }
  end

  def with_barrier(walker, barrier) when is_binary(barrier) do
    __MODULE__.with_barrier(walker, Regex.compile!(barrier))
  end

  @spec destroy_barrier(__MODULE__.t()) :: __MODULE__.t()
  def destroy_barrier(walker) do
    if !is_barried(walker) do
      raise "trying to destroy a barrier of an unbarrier Walker. This shouldn`t never happen"
    end

    %__MODULE__{
      walker
      | barrier: ~r"$a",
        rest: walker.barriered,
        barriered: ""
    }
  end

  @doc ~S"""
  Consume the current walk input

  ## Examples

      iex> Olx.Walker.consume_input(Olx.Walker.start("abc"))
      %Olx.Walker{input: "", rest: "bc", column: 1}
  """
  @spec consume_input(__MODULE__.t()) :: __MODULE__.t()
  def consume_input(walker) do
    %__MODULE__{
      walker
      | input: ""
    }
  end

  defp increment_line("\n"), do: 1
  defp increment_line(_), do: 0
  defp increment_column("\n"), do: 0
  defp increment_column(_), do: 1
end
