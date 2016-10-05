# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :flask_scraper,
  requests_per_second: 100,
  requests_per_hour: 36_000,
  item_not_found: %{reason: "Unable to get item information.", status: "nok"}

config :logger,
  level: :info

import_config "secrets.exs"
