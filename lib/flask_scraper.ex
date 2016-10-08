defmodule FlaskScraper do
  @moduledoc """
  The main module of the FlaskScraper.
  """
  use Application
  alias FlaskScraper.Scraper

  def main(_args) do
    run(FlaskScraper.ItemSet, 1..1_400)
    run(FlaskScraper.Item, 1..175_000)
  end

  def run(model, range) do
    Scraper.scrape(model, range)
  end

  def rps, do: Application.get_env(:flask_scraper, :requests_per_second)
  def rph, do: Application.get_env(:flask_scraper, :requests_per_hour)
  def trps, do: div(rph, 3600)
  def gap_time, do: div(rps, trps)

  # Let us use Ecto.
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [supervisor(FlaskScraper.Repo, [])]
    opts = [strategy: :one_for_one, name: Foo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
