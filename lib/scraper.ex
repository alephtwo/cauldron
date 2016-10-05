defmodule FlaskScraper.Scraper do
  @moduledoc """
  A generic scraper that uses Flask.
  """
  require Logger

  def scrape(range) do
    range
      |> Enum.chunk(FlaskScraper.rps, FlaskScraper.rps, [])
      |> Enum.map(fn chunk -> process_chunk(chunk) end)
      |> List.flatten
  end

  defp process_chunk(chunk) when is_list(chunk) do
    chunk
      |> thread_groups
      |> Enum.map(&Task.async(fn -> process_subchunk(&1) end))
      |> Enum.map(&Task.await(&1))
  end

  defp process_subchunk(subchunk) when is_list(subchunk) do
    subchunk
      |> Enum.map(&Flask.item(&1))
      |> Enum.map(fn t -> handle_errors(t) end)
      |> Enum.filter(fn r -> r != :error end)
  end

  # Split the chunk into a group for each thread to work on
  defp thread_groups(chunk) do
    chunk
      |> Enum.group_by(fn x -> rem(x, FlaskScraper.trps) end)
      |> Enum.map(fn {_, t} -> t end)
  end

  defp handle_errors(tuple) do
    # TODO: Handle errors/timeouts separately
    case tuple do
      {:ok, r} -> r
      {:error, :timeout} -> :timeout
      {:error, _} -> :error
    end
  end
end
