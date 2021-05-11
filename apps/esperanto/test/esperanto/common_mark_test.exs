defmodule Esperanto.Parsers.BrParseTest do
  alias Esperanto.Parser
  alias Esperanto.Walker
  alias Esperanto.Parsers.TopLevel
  use ExUnit.Case

  test "example 1" do
    input = "\tfoo\tbaz\t\tbim\n"
    walker = %Walker{input: input}
    {tree, _walker} = TopLevel.parse(walker, nil, nil, [])
    assert "<pre><code>foo\tbaz\t\tbim\n</code></pre>" == Parser.to_xml(tree)
  end

  test "example 2" do
    input = "  \tfoo\tbaz\t\tbim\n"
    walker = %Walker{input: input}
    {tree, _walker} = TopLevel.parse(walker, nil, nil, [])
    assert "<pre><code>foo\tbaz\t\tbim\n</code></pre>" == Parser.to_xml(tree)
  end

  test "example 3" do
    input = "    a\ta\n    ὐ\ta\n"
    walker = %Walker{input: input}
    {tree, _walker} = TopLevel.parse(walker, nil, nil, [])
    assert "<pre><code>a\ta\nὐ\ta\n</code></pre>" == Parser.to_xml(tree)
  end
end
