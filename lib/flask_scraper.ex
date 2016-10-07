defmodule FlaskScraper do
  @moduledoc """
  The main module of the FlaskScraper.
  """
  alias FlaskScraper.Scraper

  def main(_args) do
    run(FlaskScraper.Item, 1..100)
  end

  def run(model, range) do
    {finds, faults} =
      model
        |> Scraper.scrape(range)
        |> Enum.partition(fn {sym, _} -> sym == :ok end)

    write_scrapes(model, finds)
    write_errors(model, faults)
  end

  def rps, do: Application.get_env(:flask_scraper, :requests_per_second)
  def rph, do: Application.get_env(:flask_scraper, :requests_per_hour)
  def trps, do: div(rph, 3600)
  def gap_time, do: div(rps, trps)

  defp write_scrapes(model, finds) do
    scrapes = Enum.map(finds, fn {:ok, i} -> i end)
    File.write("./#{model.desc}_scrape.json", Poison.encode!(scrapes), [:binary])
  end
  defp write_errors(model, faults) do
    errors =
      faults
        |> Enum.map(fn {:error, err} -> err end)
        |> Enum.filter(fn %{error: err, id: _} -> err != model.not_found end)
    File.write(
      "./#{model.desc}_errors.json",
      Poison.encode!(errors),
      [:binary]
    )
  end
end
