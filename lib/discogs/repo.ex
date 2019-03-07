defmodule Discogs.Repo do
  @moduledoc """
  Repo entry point.
  """
  use Ecto.Repo, otp_app: :discogs, adapter: Sqlite.Ecto2

  def main(args) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    parse =
      OptionParser.parse(
        args,
        switches: [sync: :boolean],
        aliases: [s: :sync]
      )

    case parse do
      {[sync: true], [username], _} -> {:sync, username}
      _ -> :help
    end
  end

  defp process(:help) do
    IO.puts("""
    Usage: discogs [options]
        -s, --sync <USER>    Sync a user collection
    """)
  end

  defp process({:sync, username}), do: sync(username)

  defp sync(username) do
    username
    |> Discogs.User.get_or_create_by_name()
    |> Discogs.JSONFetch.fetch_releases_by_user()
    |> Discogs.JSONSanitize.extract_from_json()
    |> Discogs.SyncModels.sync_models()
  end
end
