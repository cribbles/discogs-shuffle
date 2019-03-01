defmodule Discogs.ExtractReleases do
  def extract_from_json(map) do
    {:ok, body} = map
    next_url = get_in(body, ["pagination", "urls", "next"])
    releases = get_releases(body)
    {next_url, releases}
  end

  defp get_releases(body) do
    body
    |> get_in(["releases"])
    |> Enum.map(&(extract_release_fields(&1)))
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

