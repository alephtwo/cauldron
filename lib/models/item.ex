defmodule FlaskScraper.Item do
  @moduledoc """
  Models an Item from the Battle.net API.
  """
  def desc, do: "item"

  def get(id), do: Flask.item(id)
  def not_found, do: %{reason: "Unable to get item information.", status: "nok"}
  def describe(item), do: "#{item[:id]} - #{item[:name]}"
end
