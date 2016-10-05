defmodule FlaskScraper do
  @moduledoc """
  The main module of the FlaskScraper.
  """
  alias FlaskScraper.Scraper

  def main(_args) do
    Scraper.scrape(1..100)
  end

  def rps, do: Application.get_env(:flask_scraper, :requests_per_second)
  def rph, do: Application.get_env(:flask_scraper, :requests_per_hour)
  def trps, do: div(rph, 3600)
  def gap_time, do: div(rps, trps)
end
