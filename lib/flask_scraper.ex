defmodule FlaskScraper do
  @moduledoc """
  The main module of the FlaskScraper.
  """
  alias FlaskScraper.Scraper
  use Application

  # Allow us to use Ecto.
  def start(_type, _args) do
    import Supervisor.Spec
    tree = [supervisor(FlaskScraper.Repo, [])]
    options = [name: FlaskScraper.Sup, strategy: :one_for_one]
    Supervisor.start_link(tree, options)
  end

  def main(_args) do
    run(FlaskScraper.Item, 1..100)
  end

  def run(model, range) do
    {finds, faults} =
      model
        |> Scraper.scrape(range)
        |> Enum.partition(fn {sym, _} -> sym == :ok end)

    scrapes = Enum.map(finds, fn {:ok, i} -> i end)
    File.write("./scrape.json", Poison.encode!(scrapes), [:binary])

    unless Enum.empty?(faults) do
      errors =
        faults
          |> Enum.map(fn {:error, err} -> err end)
          |> Enum.filter(fn %{error: err, id: _} -> err != model.not_found end)
      File.write("./errors.json", Poison.encode!(errors), [:binary])
    end
  end

  def rps, do: Application.get_env(:flask_scraper, :requests_per_second)
  def rph, do: Application.get_env(:flask_scraper, :requests_per_hour)
  def trps, do: div(rph, 3600)
  def gap_time, do: div(rps, trps)
end
