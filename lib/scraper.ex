defmodule FlaskScraper.Scraper do
  @moduledoc """
  A generic scraper that uses Flask.
  """
  use Timex
  require Logger

  def scrape(range) do
    {:ok, eta} =
      Timex.now
      |> Timex.shift(seconds: div(Enum.count(range), FlaskScraper.trps))
      |> Timex.format("{relative}", :relative)
    Logger.info "ETA: #{eta}"

    range
      |> Enum.chunk(FlaskScraper.rps, FlaskScraper.rps, [])
      |> Enum.map(fn chunk -> process_chunk(chunk) end)
      |> List.flatten
  end

  defp process_chunk(chunk) when is_list(chunk) do
    start = Duration.from_erl(:os.timestamp)

    results =
      chunk
        |> thread_groups
        |> Enum.map(&Task.async(fn -> process_subchunk(&1) end))
        |> Enum.map(&Task.await(&1))

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

  defp process_subchunk(subchunk) when is_list(subchunk) do
    responses =
      subchunk
        |> Enum.map(fn id -> %{id: id, item: Flask.item(id)} end)
        |> Enum.map(fn item -> wrap_error(item) end)

    log_finds(responses)
    responses
  end

  # Split the chunk into a group for each thread to work on
  defp thread_groups(chunk) do
    chunk
      |> Enum.group_by(fn x -> rem(x, FlaskScraper.trps) end)
      |> Enum.map(fn {_, t} -> t end)
  end

  defp wrap_error(%{id: _id, item: {:ok, item}}), do: {:ok, item}
  defp wrap_error(%{id: id, item: {:error, status}}) do
    # Don't write out item not found
    unless status == FlaskScraper.item_not_found do
      Logger.error "#{id} failed: #{inspect(status)}"
    end
    {:error, %{id: id, error: status}}
  end

  defp log_finds(responses) when is_list(responses) do
    responses
      |> Enum.filter(fn {sym, _} -> sym == :ok end)
      |> Enum.map(fn {:ok, r} -> Map.take(r, [:id, :name]) end)
      |> Enum.map(fn r -> "#{Map.get(r, :id)} - #{Map.get(r, :name)}" end)
      |> Enum.map(fn s -> "#{inspect(self)} #{s}" end)
      |> Enum.each(&Logger.info(&1))
  end
end
