defmodule Cauldron.ItemSet do
  @moduledoc """
  Models an Item from the Battle.net API.
  """
  def desc, do: "item_set"

  def get(id), do: Flask.item_set(id)
  def not_found do
    %{reason: "Unable to get item set information.", status: "nok"}
  end
  def describe(set), do: "#{set[:id]} - #{set[:name]}"
end
