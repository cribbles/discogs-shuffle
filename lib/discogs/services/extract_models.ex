defmodule Discogs.ExtractModels do
  import Discogs.Helpers, only: [pick: 2]

  def extract_release_models({:ok, user, releases}) do
    {:ok, user, releases, %{releases: get_release_models(releases)}}
  end

  def extract_relationship_models({:ok, user, releases, models}) do
    relationship_models = get_relationship_models(user, models.releases)
    {:ok, user, releases, Map.merge(models, relationship_models)}
  end

  defp get_release_models(releases) do
    pick(releases, [:discogs_id, :name, :records])
  end

  defp get_relationship_models(user, releases) do
    %{
      user: user |> Ecto.Changeset.change(releases: releases),
      artists: get_artist_models(releases),
    }
  end

  defp get_artist_models(releases) do
    Enum.reduce(releases, %{}, fn release, all_artists ->
      release_artists = get_artist_models(all_artists, release)
      Map.merge(all_artists, release_artists)
    end)
  end

  defp get_artist_models(artists, release) do
    Enum.reduce(artists, %{}, fn artist, artists ->
      artist_releases = MapSet.union(
        Map.get(artist, :releases, %MapSet{}),
        MapSet.new([release])
      )
      artist_with_releases = Map.put(artist, :releases, artist_releases)
      Map.put(artists, artist.discogs_id, artist_with_releases)
    end)
  end
end
