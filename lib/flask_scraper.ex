defmodule FlaskScraper do
  @moduledoc """
  The main module of the FlaskScraper.
  """
  alias FlaskScraper.Scraper

  def main(_args) do
    {finds, faults} =
      1..150_000
        |> Scraper.scrape
        |> Enum.partition(fn {sym, _} -> sym == :ok end)

    scrapes = Enum.map(finds, fn {:ok, i} -> i end)
    File.write("./scrape.json", Poison.encode!(scrapes), [:binary])

    unless Enum.empty?(faults) do
      errors =
        faults
          |> Enum.map(fn {:error, err} -> err end)
          |> Enum.filter(fn %{error: err, id: _id} -> err != item_not_found end)
      File.write("./errors.json", Poison.encode!(errors), [:binary])
    end
  end

  def rps, do: Application.get_env(:flask_scraper, :requests_per_second)
  def rph, do: Application.get_env(:flask_scraper, :requests_per_hour)
  def trps, do: div(rph, 3600)
  def gap_time, do: div(rps, trps)
  def item_not_found, do: Application.get_env(:flask_scraper, :item_not_found)
end
