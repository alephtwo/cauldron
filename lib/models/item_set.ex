defmodule FlaskScraper.ItemSet do
  @moduledoc """
  Models an Item from the Battle.net API.
  """
  use Ecto.Schema
  require Logger
  alias FlaskScraper.Repo
  alias FlaskScraper.ItemSet
  alias FlaskScraper.SetBonus

  @primary_key {:id, :id, autogenerate: false}
  schema "item_set" do
    field :name, :string, size: 512
    has_many :set_bonuses, FlaskScraper.SetBonus
    timestamps
  end

  def desc, do: "item_set"
  def request(id), do: Flask.item_set(id)
  def insert_row({:error, _}), do: "" # TODO implement this
  def insert_row({:ok, set}) do
    set_bonuses = set[:setBonuses]
      |> Enum.map(fn b -> %SetBonus{
        description: b["description"],
        threshold: b["threshold"]
      } end)

    Logger.info "#{inspect(self)} #{set[:id]} - #{set[:name]}"
    %ItemSet{id: set[:id], name: set[:name]}
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:set_bonuses, set_bonuses)
      |> Repo.insert
  end
end
