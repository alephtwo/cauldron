defmodule FlaskScraper.ItemSet do
  @moduledoc """
  Models an Item from the Battle.net API.
  """
  use Ecto.Schema
  require Logger
  alias FlaskScraper.Repo
  alias FlaskScraper.ItemSet

  @primary_key {:id, :id, autogenerate: false}
  schema "item_set" do
    field :name, :string, size: 512
    timestamps
  end

  def request(id), do: Flask.item_set(id)
  def insert_row({:error, _}), do: "" # TODO implement this
  def insert_row({:ok, set}) do
    Logger.info "#{inspect(self)} #{set[:id]} - #{set[:name]}"
    Repo.insert %ItemSet{id: set[:id], name: set[:name]}
  end
end
