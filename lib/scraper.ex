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
    start = :os.system_time(:milli_seconds)

    chunk
      |> thread_groups
      |> Enum.map(&Task.async(fn -> process_subchunk(&1) end))
      |> Enum.map(&Task.await(&1))

    finish = :os.system_time(:milli_seconds)
    rate_limit = (FlaskScraper.gap_time * 1000) - (finish - start)
    if rate_limit > 0 do
      Logger.debug "#{inspect(self)} sleeping for #{rate_limit}ms"
      :timer.sleep(rate_limit)
    end

    chunk
  end

  defp process_subchunk(subchunk) when is_list(subchunk) do
    responses =
      subchunk
        |> Enum.map(&Flask.item(&1))
        |> Enum.map(fn t -> handle_errors(t) end)
        |> Enum.filter(fn r -> r != :error end)

    log_finds(responses)
    responses
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

  defp log_finds(responses) when is_list(responses) do
    responses
      |> Enum.map(fn r -> Map.take(r, [:id, :name]) end)
      |> Enum.map(fn r -> "#{Map.get(r, :id)} - #{Map.get(r, :name)}" end)
      |> Enum.map(fn s -> "#{inspect(self)} #{s}" end)
      |> Enum.each(&Logger.info(&1))
  end
end
