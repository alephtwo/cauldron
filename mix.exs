defmodule Cauldron.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cauldron,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: [main_module: Cauldron]
    ]
  end

  def application do
    [
      applications: [:logger, :flask, :timex, :ecto, :postgrex],
      mod: {Cauldron, []}
    ]
  end

  defp deps do
    [
      {:flask, github: "alephtwo/flask", ref: "984187bc391fb2d5b6fb6c75667c78eb1d76d3fc"},
      {:timex, "~> 3.0"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:tzdata, "== 0.1.8", override: true}, # Required for escript timex
      {:ecto, "~> 2.0"},
      {:postgrex, "~> 0.12"}
    ]
  end
end
