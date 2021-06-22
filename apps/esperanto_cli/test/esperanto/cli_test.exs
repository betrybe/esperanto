defmodule Esperanto.CliTest do
  use ExUnit.Case
  doctest Esperanto.Cli

  test "greets the world" do
    assert Esperanto.Cli.hello() == :world
  end
end
