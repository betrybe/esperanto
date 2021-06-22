defmodule Esperanto.Olx.Problem do
  @moduledoc """
  Parse and OLX problem
  """

  alias Esperanto.Parser
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker

  def parse(input) do
    parsers = [
      {Esperanto.Olx.Parsers.Label, nil},
      {Esperanto.Olx.Parsers.IncorrectChoice, nil},
      {Esperanto.Olx.Parsers.CorrectChoice, nil},
      {Esperanto.Olx.Parsers.ChoiceHint, nil}
    ]

    walker =
      if String.ends_with?(input, "\n") do
        Walker.start(input)
      else
        Walker.start(input <> "\n")
      end

    multiple_choice_response = NaryTree.Node.new(:multiplechoiceresponse)

    tree =
      NaryTree.Node.new(:problem)
      |> NaryTree.new()
      |> NaryTree.add_child(multiple_choice_response)

    TopLevel.parse(walker, tree, multiple_choice_response.id,
      parsers: TopLevel.default_parsers() ++ parsers
    )
  end

  def to_xml(input, opts \\ []) do
    input
    |> parse()
    |> elem(0)
    |> Parser.to_xml(opts)
  end

  def to_struct(doc) do
    import SweetXml

    doc
    |> SweetXml.parse()
    |> xpath(~x"/problem/multiplechoiceresponse"e)
    |> question_to_struct()
  end

  defp to_xml_str(element) do
    element
    |> :xmerl.export_simple_content(:xmerl_xml)
    |> List.flatten()
  end

  defp question_to_struct(element) do
    %{
      question: label_to_struct(element),
      choices: choices_to_struct(element)
    }
  end

  defp label_to_struct(element) do
    import SweetXml

    element
    |> xpath(~x"./label"l)
    |> to_xml_str()
  end

  defp choices_to_struct(element) do
    import SweetXml

    element
    |> xpath(~x"./choicegroup/choice"l)
    |> Enum.map(&choice_to_struct/1)
  end

  defp choice_to_struct(choice_node) do
    import SweetXml

    is_correct =
      choice_node
      |> xpath(~x"./@correct"l)
      |> to_xml_str()

    choice_hint =
      choice_node
      |> xpath(~x"./choicehint/*"l)
      |> to_xml_str()

    content =
      choice_node
      |> xpath(~x"./*[not(self::choicehint)]"l)
      |> to_xml_str()

    %{
      content: content,
      choicehint: choice_hint,
      is_correct: is_correct
    }
  end
end
