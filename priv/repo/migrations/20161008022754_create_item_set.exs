defmodule FlaskScraper.Repo.Migrations.CreateItemSet do
  use Ecto.Migration

  def change do
    create table (:item_set) do
      add :name, :string, size: 512
      timestamps
    end
  end
end
