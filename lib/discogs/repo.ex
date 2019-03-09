defmodule Discogs.Repo do
  @moduledoc """
  Repo entry point.
  """
  @default_num_records 30
  use Ecto.Repo, otp_app: :discogs, adapter: Sqlite.Ecto2
  alias Discogs.{Record, Release, Repo, Services, User}

  def main(args) do
    args |> parse |> process
  end

  defp parse(args) do
    parsed =
      OptionParser.parse(
        args,
        strict: [
          sync: :string,
          shuffle: :string
        ]
      )

    case parsed do
      {[sync: username], [], []} ->
        {:sync, username}

      {[shuffle: username], [], []} ->
        {:shuffle, username, @default_num_records}

      {[shuffle: username], [num_records], []} ->
        {:shuffle, username, String.to_integer(num_records)}

      {_, _, _} ->
        :help
    end
  end

  defp process(:help) do
    IO.puts("""
    Usage: discogs [options]
        --sync USER             Sync a user collection
        --shuffle USER <N=30>   Pick n random records from a user collection
    """)
  end

  defp process({:sync, username}) do
    sync(username)
  end

  defp process({:shuffle, username, num_records}) do
    shuffle(username, num_records)
  end

  defp sync(username) do
    username
    |> User.get_or_create_by_name()
    |> Services.JSONFetch.fetch_releases_by_user()
    |> Services.JSONSanitize.extract_from_json()
    |> Services.SyncModels.sync_models()
  end

  defp shuffle(username, num_records) do
    username
    |> User.get_or_create_by_name()
    |> Map.get(:records)
    |> Enum.shuffle()
    |> Enum.take(num_records)
    |> Repo.preload([:release, release: [:records, :artists]])
    |> Enum.map(&output_formatted_name/1)
  end

  defp output_formatted_name(record) do
    record
    |> Record.format_name(&Release.format_name/1)
    |> IO.puts()
  end
end
