# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :cauldron, Cauldron.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "cauldron_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :cauldron, ecto_repos: [Cauldron.Repo]

config :cauldron,
  requests_per_second: 100,
  requests_per_hour: 36_000

config :logger,
  level: :info

import_config "secrets.exs"
