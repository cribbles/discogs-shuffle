defmodule Discogs.JSONSanitize do
  import Discogs.Helpers, only: [pick: 2]

  def extract_from_json({:ok, user, releases}) do
    {:ok, user, extract_release_fields(releases)}
  end

  defp extract_release_fields(releases) when is_list(releases) do
    Enum.map(releases, &extract_release_fields/1)
  end

  defp extract_release_fields(release) do
    %{
      artists: get_artists(release),
      discogs_id: get_in(release, ["basic_information", "id"]),
      name: get_in(release, ["basic_information", "title"]),
      records: get_records(release),
    }
  end

  defp get_artists(release) do
    release
    |> get_in(["basic_information", "artists"])
    |> pick(["id", "name"])
    |> Enum.map(&%{discogs_id: &1["id"], name: &1["name"]})
  end

  defp get_records(release) do
    release
    |> get_disc_count
    |> generate_records
  end

  defp get_disc_count(release) do
    release
    |> get_in(["basic_information", "formats"])
    |> Enum.at(0)
    |> get_in(["qty"])
    |> String.to_integer
  end

  defp generate_records(disc_count) do
    for disc_number <- 1..disc_count, do: %{disc_number: disc_number}
  end
end
