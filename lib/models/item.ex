defmodule FlaskScraper.Item do
  def get(id), do: Flask.item(id)
  def not_found, do: %{reason: "Unable to get item information.", status: "nok"}
  def describe(item), do: "#{item[:id]} - #{item[:name]}"
end
