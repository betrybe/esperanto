defmodule Esperanto.Parsers.CommonMarkTest do
  alias Esperanto.Parser
  alias Esperanto.Parsers.TopLevel
  alias Esperanto.Walker
  use ExUnit.Case

  @doc """
  https://spec.commonmark.org/0.29/#example-1
  """
  test "example 1" do
    input = "\tfoo\tbaz\t\tbim\n"
    walker = %Walker{input: input}
    {tree, _walker} = TopLevel.parse(walker, nil, nil, [])
    assert "<pre><code>foo\tbaz\t\tbim\n</code></pre>" == Parser.to_xml(tree)
  end

  @doc """
  https://spec.commonmark.org/0.29/#example-2
  """
  test "example 2" do
    input = "  \tfoo\tbaz\t\tbim\n"
    walker = %Walker{input: input}
    {tree, _walker} = TopLevel.parse(walker, nil, nil, [])
    assert "<pre><code>foo\tbaz\t\tbim\n</code></pre>" == Parser.to_xml(tree)
  end

  @doc """
  https://spec.commonmark.org/0.29/#example-3
  """
  test "example 3" do
    input = "    a\ta\n    ὐ\ta\n"
    walker = %Walker{input: input}
    {tree, _walker} = TopLevel.parse(walker, nil, nil, [])
    assert "<pre><code>a\ta\nὐ\ta\n</code></pre>" == Parser.to_xml(tree)
  end
end
