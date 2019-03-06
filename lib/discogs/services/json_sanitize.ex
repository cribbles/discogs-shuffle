defmodule Discogs.JSONSanitize do
  def extract_from_json({:ok, user, releases}) do
    {:ok, user, extract_release_fields(releases)}
  end

  defp extract_release_fields(releases) when is_list(releases) do
    Enum.reduce(releases, %{}, fn (release, releases) ->
      id = get_in(release, ["basic_information", "id"])
      if is_map(releases[id]),
        do: releases,
        else: Map.put(releases, id, extract_release_fields(release, id))
    end)
    |> Map.values
  end

  defp extract_release_fields(release, discogs_id) do
    %{
      artists: get_artists(release),
      discogs_id: discogs_id,
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

  defp pick(map, values) do
    Enum.map(map, &(Map.take(&1, values)))
  end
end
