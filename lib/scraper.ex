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
      |> Enum.map(fn chunk -> process_chunk(model, chunk) end)
      |> List.flatten
  end

  defp process_chunk(model, chunk) when is_list(chunk) do
    start = Duration.from_erl(:os.timestamp)

    results =
      chunk
        |> thread_groups
        |> Enum.map(&Task.async(fn -> process_subchunk(model, &1) end))
        |> Enum.map(&Task.await(&1, 30_000))

    elapsed =
      Duration.from_erl(:os.timestamp)
      |> Duration.elapsed(start, :milliseconds)

    rate_limit = (FlaskScraper.gap_time * 1000) - elapsed
    if rate_limit > 0 do
      Logger.debug "#{inspect(self)} sleeping for #{rate_limit}ms"
      :timer.sleep(rate_limit)
    end

    results
  end

  defp process_subchunk(model, subchunk) when is_list(subchunk) do
    responses =
      subchunk
        |> Enum.map(fn id -> %{id: id, item: model.get(id)} end)
        |> Enum.map(fn item -> wrap_error(model, item) end)

    log_finds(model, responses)
    responses
  end

  # Split the chunk into a group for each thread to work on
  defp thread_groups(chunk) do
    chunk
      |> Enum.group_by(fn x -> rem(x, FlaskScraper.trps) end)
      |> Enum.map(fn {_, t} -> t end)
  end

  defp wrap_error(_, %{id: _id, item: {:ok, item}}), do: {:ok, item}
  defp wrap_error(model, %{id: id, item: {:error, status}}) do
    # Don't write out item not found
    unless status == model.not_found do
      Logger.error "#{id} failed: #{inspect(status)}"
    end
    {:error, %{id: id, error: status}}
  end

  defp log_finds(model, responses) when is_list(responses) do
    responses
      |> Enum.filter(fn {sym, _} -> sym == :ok end)
      |> Enum.map(fn {:ok, item} -> model.describe(item) end)
      |> Enum.map(fn s -> "#{inspect(self)} #{s}" end)
      |> Enum.each(&Logger.info(&1))
  end
end
