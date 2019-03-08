use Mix.Config

config :discogs, Discogs.Repo,
  adapter: Sqlite.Ecto2,
  database: "test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox

config :discogs, ecto_repos: [Discogs.Repo]
