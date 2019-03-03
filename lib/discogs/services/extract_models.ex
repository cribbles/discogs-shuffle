defmodule Discogs.ExtractModels do
  # use Ecto.Schema
  # alias Discogs.User
  # alias Discogs.Artist
  # alias Discogs.Release
  # alias Discogs.Record
  # alias Discogs.ArtistRelease
  # alias Discogs.UserRelease

  def extract_from_json({:ok, _, releases}) do
    {:ok, Enum.map(releases, &extract_release_fields/1)}
  end

  defp extract_release_fields(release) do
    artists = get_in(release, ["basic_information", "artists"])

    %{
      artists: pick(artists, ["id", "name"]),
      id: get_in(release, ["basic_information", "id"]),
      title: get_in(release, ["basic_information", "title"]),
      num_records: get_num_records(release)
    }
  end

  defp get_num_records(release) do
    release
    |> get_in(["basic_information", "formats"])
    |> Enum.at(0)
    |> get_quantity
  end

  defp get_quantity(format) do
    format
    |> get_in(["qty"])
    |> String.to_integer
  end

  defp pick(map, values) do
    Enum.map(map, &(Map.take(&1, values)))
  end
end
