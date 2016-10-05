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
    [applications: [:logger, :flask]]
  end

  defp deps do
    [
      {:flask, github: "alephtwo/flask", ref: "162cbab1fb76d360a7ca2b6976f577c5b2ba612f"},
      {:credo, "~> 0.4", only: [:dev, :test]}
    ]
  end
end
