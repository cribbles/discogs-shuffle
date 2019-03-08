use Mix.Config

config :discogs, Discogs.Repo,
  adapter: Sqlite.Ecto2,
  database: "discogs.sqlite3"

config :discogs, ecto_repos: [Discogs.Repo]
