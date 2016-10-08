defmodule FlaskScraper.Repo.Migrations.CreateSetBonus do
  use Ecto.Migration

  def change do
    create table(:set_bonus, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :item_set_id, references(:item_set)
      add :description, :string, size: 2048
      add :threshold, :integer
    end
  end
end
