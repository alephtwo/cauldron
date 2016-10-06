defmodule FlaskScraper.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create_table(:items, primary_key: false) do
      add :flask_id, :uuid, primary_key: true

      # Things we likely care about
      add :id, :integer
      add :name, :string
      add :description, :string
      add :name_description, :string
      add :name_description_color, :string
      add :icon, :string
      add :item_level, :integer
      add :required_level, :integer
      add :required_skill, :integer
      add :required_skill_rank, :integer
      add :sell_price, :integer
      add :buy_price, :integer
      add :context, :string
      add :armor, :integer
      add :base_armor, :integer
      add :min_reputation, :integer
      add :max_count, :integer
      add :quality, :integer
      add :container_slots, :integer
      add :stackable, :integer
      add :disenchanting_skill_rank, :integer
      add :max_durability, :integer

      # Possible Foreign Keys?
      add :display_info_id, :integer
      add :item_class, :integer
      add :item_sub_class, :integer
      add :item_bind, :integer
      add :artifact_id, :integer
      add :min_faction_id, :integer
      add :inventory_type, :integer
      add :item_set_id, :integer

      # Booleans
      add :heroic_tooltip, :boolean
      add :upgradable, :boolean
      add :has_sockets, :boolean
      add :is_auctionable, :boolean
      add :equippable, :boolean

      timestamps
    end
  end
end
