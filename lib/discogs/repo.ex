defmodule Discogs.Repo do
  use Ecto.Repo, otp_app: :discogs, adapter: Sqlite.Ecto2

  def main(args) do
    args
    |> parse_args
    |> process
  end

  def parse_args(args) do
    parse = OptionParser.parse(
      args,
      switches: [help: :boolean],
      aliases: [h: :help]
    )

    case parse do
      {[help: true], _, _} -> :help
      {_, [username], _} -> {username}
    end
  end

  def process(:help) do
    IO.puts(
      """
        Discogs
        -------
        usage: discogs <user>
        example: discogs username
      """
    )
  end

  def process({username}) do
    sync(username)
  end

  def sync(username) do
    username
    |> Discogs.User.get_or_create_by_name
    |> Discogs.JSONFetch.fetch_releases_by_user
    |> Discogs.ExtractModels.extract_from_json
    |> Discogs.SyncModels.sync
  end
end
