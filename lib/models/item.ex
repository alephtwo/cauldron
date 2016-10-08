defmodule FlaskScraper.Item do
  @moduledoc """
  Models an Item from the Battle.net API.
  """
  use Ecto.Schema
  require Logger
  alias FlaskScraper.Repo
  alias FlaskScraper.Item

  @primary_key {:id, :id, autogenerate: false}
  schema "item" do
    field :name, :string, size: 512
    timestamps
  end

  def request(id), do: Flask.item(id)
  def insert_row({:error, _}), do: "" # TODO implement this
  def insert_row({:ok, item}) do
    Logger.info "#{inspect(self)} #{item[:id]} - #{item[:name]}"
    Repo.insert %Item{id: item[:id], name: item[:name]}
  end
end
