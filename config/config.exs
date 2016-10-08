# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :flask_scraper, FlaskScraper.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "flask_scraper_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :flask_scraper, ecto_repos: [FlaskScraper.Repo]

config :flask_scraper,
  requests_per_second: 100,
  requests_per_hour: 36_000

config :logger,
  level: :info

import_config "secrets.exs"
