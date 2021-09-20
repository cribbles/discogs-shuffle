defmodule Discogs.Services.JSONSanitize do
  @moduledoc """
  Massages Discogs JSON properties into attribute maps ready for use by Ecto
  changesets.
  """

  @doc """
  Extracts the relevant attributes from Discogs `Release` JSON needed create an
  Ecto changeset with valid properties and associations.

  Includes support for associations:
  - `Artist`
  - `Record`

  Note that this only returns the _attributes_ - not the `%Release{}` structs
  themselves.
  """
  @typedoc "Discogs JSON API release payload properties"
  @type release_json :: %{optional(any) => any}
  @typedoc "`%Discogs.Release{}` changeset attributes"
  @type release_attrs :: %{optional(any) => any}
  @spec get_release_params([release_json]) :: [release_attrs]
  def get_release_params(releases_json) do
    releases_json
    |> get_release_fields()
    |> Map.values()
  end

  defp get_release_fields(releases) when is_list(releases) do
    Enum.reduce(releases, %{}, fn release, releases ->
      id = get_in(release, ["basic_information", "id"])

      if is_map(releases[id]),
        do: releases,
        else: Map.put(releases, id, get_release_fields(release, id))
    end)
  end

  defp get_release_fields(release, discogs_id) do
    %{
      artists: get_artists(release),
      discogs_id: discogs_id,
      name: get_in(release, ["basic_information", "title"]),
      records: get_records(release)
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
    |> String.to_integer()
  end

  defp generate_records(disc_count) do
    for disc_number <- 1..disc_count, do: %{disc_number: disc_number}
  end

  defp pick(map, values) do
    Enum.map(map, &Map.take(&1, values))
  end
end
