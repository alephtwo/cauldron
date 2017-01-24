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
      {:flask, github: "alephtwo/flask", ref: "f5978443d404d095f327a6b91312ce528cac14d1"},
      {:timex, "~> 3.1.8"},
      {:credo, "~> 0.6", only: [:dev, :test]},
      {:tzdata, "== 0.5.10", override: true}, # Required for escript timex,
      {:ecto, "~> 2.0"},
      {:postgrex, "~> 0.12"}
    ]
  end
end
