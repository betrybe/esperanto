defmodule Esperanto.Olx.RealExamples do
  alias Esperanto.Olx.Problem
  use ExUnit.Case

  @fixtures_path "test/fixtures/"

  for dir <- [
    "quiz-145-11-1/",
    "quiz-148-12-1/"
    ] do
    describe "dir #{dir}" do
      for file <-
            (@fixtures_path <> dir)
            |> File.ls!()
            |> Enum.filter(&String.ends_with?(&1, ".md"))
            |> Enum.map(&String.replace_suffix(&1, ".md", "")) do
        test "file #{file} " do
          file = unquote(file)
          dir = unquote(dir)


          parsersed_xml =
            (@fixtures_path <> dir <> file <> ".md")
            |> File.read!()
            |> Problem.to_xml()

          expected_xml =
            (@fixtures_path <> dir <> file <> ".xml")
            |> File.read!()
            |> String.trim()
            |> String.replace(~r/>[[:blank:]\n]+</, "><")


          assert parsersed_xml == expected_xml
        end
      end
    end
  end

  # test_with_params "fixtures", fn dir ->
  #   (@fixtures_path <> dir)
  #   |> File.ls!()
  #   |> Enum.filter(&String.ends_with?(&1, ".md"))
  #   |> Enum.each(fn file ->

  #   end)
  # end do
  #   ["quiz-145-11-1"]
  # end
end
