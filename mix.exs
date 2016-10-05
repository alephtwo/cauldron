defmodule FlaskScraper.Mixfile do
  use Mix.Project

  def project do
    [app: :flask_scraper,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     escript: [main_module: FlaskScraper]]
  end

  def application do
    [applications: [:logger, :flask, :timex]]
  end

  defp deps do
    [
      {:flask, github: "alephtwo/flask", ref: "cf48f0ce05cbabaf01e529833b31abb5c11064b1"},
      {:timex, "~> 3.0"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:tzdata, "== 0.1.8", override: true} # Required for escript timex
    ]
  end
end
