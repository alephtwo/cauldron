defmodule FlaskScraper.Scraper do
  @moduledoc """
  A generic scraper that uses Flask.
  """
  use Timex
  require Logger

  def scrape(model, range) do
    {:ok, eta} =
      Timex.now
      |> Timex.shift(seconds: div(Enum.count(range), FlaskScraper.trps))
      |> Timex.format("{relative}", :relative)
    Logger.info "ETA: #{eta}"

    range
      |> Enum.chunk(FlaskScraper.rps, FlaskScraper.rps, [])
      |> Enum.each(fn chunk -> process_chunk(model, chunk) end)
  end

  defp process_chunk(model, chunk) when is_list(chunk) do
    start = Duration.from_erl(:os.timestamp)

    chunk
      |> thread_groups
      |> Enum.map(&Task.async(fn -> process_subchunk(model, &1) end))
      |> Enum.each(&Task.await(&1, 30_000))

    elapsed = :os.timestamp
      |> Duration.from_erl
      |> Duration.elapsed(start, :milliseconds)

    rate_limit = (FlaskScraper.gap_time * 1000) - elapsed
    if rate_limit > 0 do
      Logger.debug "#{inspect(self)} sleeping for #{rate_limit}ms"
      :timer.sleep(rate_limit)
    end
  end

  defp process_subchunk(model, subchunk) when is_list(subchunk) do
    responses = Enum.map(subchunk, fn id -> model.request(id) end)
    # Write to DB
    Enum.each(responses, fn r -> model.insert_row(r) end)
  end

  # Split the chunk into a group for each thread to work on
  defp thread_groups(chunk) do
    chunk
      |> Enum.group_by(fn x -> rem(x, FlaskScraper.trps) end)
      |> Enum.map(fn {_, t} -> t end)
  end
end
