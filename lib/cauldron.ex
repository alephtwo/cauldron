defmodule Cauldron do
  @moduledoc """
  The main module of the Cauldron.
  """
  use Application
  alias Cauldron.Scraper

  def main(_args) do
    run(Cauldron.ItemSet, 1..1_400)
    run(Cauldron.Item, 1..175_000)
  end

  def run(model, range) do
    Scraper.scrape(model, range)
  end

  def rps, do: Application.get_env(:cauldron, :requests_per_second)
  def rph, do: Application.get_env(:cauldron, :requests_per_hour)
  def trps, do: div(rph, 3600)
  def gap_time, do: div(rps, trps)

  # Let us use Ecto.
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [supervisor(Cauldron.Repo, [])]
    opts = [strategy: :one_for_one, name: Cauldron.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
