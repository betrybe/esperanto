defmodule Esperanto.Cli do
  require Logger

  alias Esperanto.Olx.Problem

  @moduledoc """
  Documentation for `Esperanto.Cli`.
  """

  @doc """
  Hello world.

  ## Examples

      ./esperanto_cli -d ../olx/test/fixtures/quiz-150-12-1/

  """
  def main(args) do
    options = [
      switches: [directory: :string, chapter_id: :string],
      aliases: [d: :directory, c: :chapter_id]
    ]

    {opts, _, _} = OptionParser.parse(args, options)
    files = get_questions_files(Keyword.get(opts, :directory))

    questions =
      get_questions(files)
      |> build_questions_json()

    chapter_id = Keyword.get(opts, :chapter_id)

    HTTPoison.start()

    quiz_id = create_quiz(chapter_id)
    create_questions(quiz_id, questions)
  end

  defp create_questions(quiz_id, questions) do
    Enum.each(questions, fn q ->
      create_question(quiz_id, q)
    end)
  end

  defp create_question(quiz_id, question) do
    payload = Poison.encode!(%{
      question: Map.put(question, :quiz_id, quiz_id) |> Map.delete(:alternatives)
    })

    random = :rand.uniform(1000)

    question[:title]
      |> String.graphemes()
      |> IO.inspect()

    file = File.open!("hello#{random}.json", [:write])
    :ok = IO.binwrite(file, payload)

    %HTTPoison.Response{body: body} =
      HTTPoison.post!(
        "localhost:4000/api/quiz/#{quiz_id}/question",
        payload,
        [{"Content-Type", "application/json"}]
      )

    IO.inspect(body)


    question_id = Poison.decode!(body)["data"]["id"]

    Logger.info("Question created with id: #{question_id}")
    question_id
  end

  defp create_quiz(chapter_id) do
    %HTTPoison.Response{body: body} =
      HTTPoison.post!(
        "localhost:4000/api/quiz",
        Poison.encode!(%{quiz: %{chapter_id: chapter_id}}),
        [{"Content-Type", "application/json"}]
      )

    quiz_id = Poison.decode!(body)["data"]["id"]

    Logger.info("Quiz created with id: #{quiz_id}")
    quiz_id
  end

  defp build_alternaties_json(alternatives) when is_list(alternatives) do
    Enum.map(alternatives, &build_alternaties_json/1)
  end

  defp build_alternaties_json(alternative) do
    %{
      justification: alternative[:choice_hint],
      answer: alternative[:is_correct],
      text: alternative[:content]
    }
  end

  defp build_questions_json(questions) when is_list(questions) do
    Enum.map(questions, &build_questions_json/1)
  end

  defp build_questions_json(question) do
    %{
      title: question[:question],
      alternatives: build_alternaties_json(question[:choices])
    }
  end

  defp get_questions(file) when is_binary(file) do
    Logger.info("Parsing file: #{file}")

    file
    |> File.read!()
    |> Problem.to_struct()
  end

  defp get_questions(directories) when is_list(directories) do
    Enum.map(directories, &get_questions/1)
  end

  defp get_questions_files(dir) do
    files =
      dir
      |> File.ls!()
      |> Enum.filter(&String.ends_with?(&1, ".xml"))
      |> Enum.sort()

    Logger.info("files founded: #{Enum.join(files, ",")}")

    Enum.map(files, fn f -> dir <> f end)
  end
end
