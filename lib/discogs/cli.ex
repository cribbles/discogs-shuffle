defmodule Discogs.CLI do
  @moduledoc """
  Entry-point for the CLI app.

  This is used as `escript`'s `:main_module`.

  cf. https://elixirschool.com/en/lessons/advanced/escripts/
  """

  @default_num_records 30
  @usage """
  Usage: discogs [options]
      --sync USER
          Sync a user collection
      --shuffle USER <N=#{@default_num_records}>
          Pick n random records from a user collection
  """

  alias Discogs.Models.{Record, Release}
  alias Discogs.Tasks

  @doc """
  Parses the ARGV and either syncs or shuffles a user's
  collection, depending on the arguments given.

  Options include:

  `--sync USER` -> `sync_collection/1`

  `--shuffle USER <N>` -> `shuffle_collection/2`

  Invalid or no arguments defer to the usage doc.
  """
  @spec main([String]) :: :ok
  def main(argv) do
    argv |> parse |> process
    :ok
  end

  defp parse(argv) do
    parsed =
      OptionParser.parse(
        argv,
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
    IO.puts(@usage)
  end

  defp process({:sync, username}) do
    case result = Tasks.sync_collection(username) do
      {:error, status_code, body} when is_tuple(result) ->
        output_http_error(status_code, body)

      _ ->
        :ok
    end
  end

  defp process({:shuffle, username, num_records}) do
    Tasks.shuffle_collection(username, num_records)
    |> Enum.map(&output_record_name/1)
  end

  defp output_http_error(status_code, body) do
    IO.puts("sync failed with error #{status_code}: #{body}")
  end

  defp output_record_name(record) do
    record
    |> Record.format_name(&Release.format_name/1)
    |> IO.puts()
  end
end
