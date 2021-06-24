defmodule Esperanto.Cli do
  require Logger

  alias Esperanto.Olx.Problem

  @moduledoc """
  Documentation for `Esperanto.Cli`.
  """

  @doc """
  Hello world.

  ## Examples

      ./esperanto_cli  -c 537fc0f4-1be1-4cd8-8333-9432fa722672 -d ../olx/test/fixtures/quiz-150-12-1/

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

    create_quiz(chapter_id, questions)
    # create_questions(quiz_id, questions)
  end

  defp create_questions(quiz_id, questions) do
    Enum.each(questions, fn q ->
      create_question(quiz_id, q)
    end)
  end

  defp create_question(quiz_id, question) do
    payload =
      Poison.encode!(%{
        question: Map.put(question, :quiz_id, quiz_id)
      })

    %HTTPoison.Response{body: body} =
      HTTPoison.post!(
        "localhost:4000/api/quiz/#{quiz_id}/question",
        payload,
        [{"Content-Type", "application/json"}]
      )

    question_id = Poison.decode!(body)["data"]["id"]

    Logger.info("Question created with id: #{question_id}")
    question_id
  end

  defp create_quiz(chapter_id, questions) do
    %HTTPoison.Response{body: body} =
      HTTPoison.post!(
        "https://stg.quiz-api.betrybe.com/api/quiz",
        Poison.encode!(build_quiz_json(chapter_id, questions)),
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
      justification: alternative[:choicehint],
      answer: alternative[:is_correct],
      text: alternative[:content]
    }
  end

  defp build_quiz_json(chapter_id, questions) do
    %{
      quiz: %{
        chapter_id: chapter_id,
        questions: questions
      }
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
