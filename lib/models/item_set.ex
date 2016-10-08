defmodule FlaskScraper.ItemSet do
  @moduledoc """
  Models an Item from the Battle.net API.
  """
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: false}
  schema "item_set" do
    field :name, :string, size: 512
    timestamps
  end

  def desc, do: "item_set"
  def request(id), do: Flask.item_set(id)
  def not_found do
    %{reason: "Unable to get item set information.", status: "nok"}
  end
  def describe(set), do: "#{set[:id]} - #{set[:name]}"
end
