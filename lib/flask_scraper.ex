defmodule FlaskScraper do
  @moduledoc """
  The main module of the FlaskScraper.
  """
  alias FlaskScraper.Scraper

  def main(_args) do
    {finds, faults} =
      1..100
        |> Scraper.scrape
        |> Enum.partition(fn {sym, _} -> sym == :ok end)

    scraped = Enum.map(finds, fn {:ok, i} -> i end)
    File.write("./scrape.json", Poison.encode!(scraped), [:binary])

    errors = Enum.map(faults, fn {:error, err} -> err end)
    File.write("./errors.json", Poison.encode!(errors), [:binary])
  end

  def rps, do: Application.get_env(:flask_scraper, :requests_per_second)
  def rph, do: Application.get_env(:flask_scraper, :requests_per_hour)
  def trps, do: div(rph, 3600)
  def gap_time, do: div(rps, trps)
end
