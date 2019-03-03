use Mix.Config

# config :discogs, Discogs.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   database: "discogs_repo",
#   username: "user",
#   password: "pass",
#   hostname: "localhost"
#
#
# config :discogs, Discogs.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   database: "discogs_repo",
#   username: "user",
#   password: "pass",
#   hostname: "localhost"

config :discogs, Discogs.Repo,
  adapter: Sqlite.Ecto2,
  database: "discogs.sqlite3"

config :discogs, ecto_repos: [Discogs.Repo]
