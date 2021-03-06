defmodule Esperanto.MixProject do
  use Mix.Project

  def project do
    [
      app: :esperanto,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      name: "esperanto",
      licenses: ["Apache-2.0"],
      description: "Esperanto markdown parse",
      files: ~w(lib .formatter.exs mix.exs README*),
      links: %{"GitHub" => "https://github.com/betrybe/esperanto"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nary_tree, "~> 0.1.1"},
      {:xml_builder, "~> 2.1"},
      {:ex_doc, "~> 0.24.1", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.14", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
    ]
  end
end
