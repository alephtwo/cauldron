defmodule FlaskScraper.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table (:item) do
      add :name, :string, size: 512
      timestamps
    end
  end
end
