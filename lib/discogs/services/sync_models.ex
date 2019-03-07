defmodule Discogs.SyncModels do
  @moduledoc """
  Converts maps with release attributes into Ecto release structs, then upserts
  the structs along with their associations.

  This could be refactored to leverage something like Ecto.Multi and upsert
  associations (artists, records, user-releases) separately from the releases.
  """
  alias Discogs.Artist
  alias Discogs.Release
  alias Discogs.Repo
  alias Ecto.Changeset

  def sync_models({:ok, user, releases}) do
    for release <- releases, do: sync_release(user, release)
  end

  defp sync_release(user, releases) do
    {artists, rest_attrs} = Map.pop(releases, :artists)
    artist_models = Enum.map(artists, &Artist.get_or_create/1)
    {status, struct_or_changeset} = Release.get_struct_or_changeset(rest_attrs)

    change =
      case status do
        :release -> %{users: [user | struct_or_changeset.users]}
        :changeset -> %{users: [user], artists: artist_models}
      end

    struct_or_changeset |> Changeset.change(change) |> Repo.insert_or_update!()
  end
end
