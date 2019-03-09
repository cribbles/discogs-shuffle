defmodule Discogs.Services.SyncModels do
  @moduledoc """
  Converts maps with release attributes into Ecto release structs, then:

  1) upserts the structs along with their associations
  2) removes User -> Release associations missing from the release list

  This could be refactored to leverage something like Ecto.Multi and upsert
  associations (artists, records, user-releases) separately from the releases.
  """
  alias Discogs.{Artist, Release, Repo, UserRelease}
  alias Ecto.Changeset

  def sync_models({:ok, user, releases}) do
    user
    |> sync_user_releases(releases)
    |> remove_old_user_releases(user)
  end

  defp sync_user_releases(user, releases) do
    for release <- releases, do: sync_user_release(user, release)
  end

  defp sync_user_release(user, releases) do
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

  defp remove_old_user_releases(releases, user) do
    release_ids = Enum.reduce(releases, %MapSet{}, &MapSet.put(&2, &1.id))
    old_releases = Enum.reject(user.releases, &MapSet.member?(release_ids, &1.id))

    for release <- old_releases do
      %UserRelease{user_id: user.id, release_id: release.id}
      |> Repo.delete!()
    end
  end
end
