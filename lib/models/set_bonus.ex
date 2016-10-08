defmodule FlaskScraper.SetBonus do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "set_bonus" do
    belongs_to :item_set, FlaskScraper.ItemSet
    field :description, :string, size: 2048
    field :threshold, :integer
  end
end
