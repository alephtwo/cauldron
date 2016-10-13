# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :cauldron,
  requests_per_second: 100,
  requests_per_hour: 36_000

config :logger,
  level: :info

import_config "secrets.exs"
