defmodule Discogs.Services.SyncUserCollection do
  @moduledoc """
  Syncs releases and associated data types and adds them to a user's
  collection.
  """
  alias Discogs.Models.{Artist, Release, User, UserRelease}
  alias Discogs.Repo
  alias Ecto.Changeset

  @doc """
  Converts `Release` attribute maps into `%Discogs.Release{}` structs, then:

  1. upserts the structs along with their associations
  2. removes `User` -> `Release` associations missing from the release list

  `User` -> `Release` associations can be missing when a user has removed a
  release from their collection, for example when a release is sold or lost.
  In that case we want to make sure the association is not cast.

  This could be restructured to leverage something like `Ecto.Multi` and upsert
  associations (`Artist`s, `Record`s, `UserRelease`s) separately from the
  `Release`s.
  """
  @type release_params :: Release.params()
  @spec sync([release_params], %User{}) :: {:ok, %User{}}
  def sync(release_params_list, user) do
    synced_releases = sync_user_releases(user, release_params_list)
    drop_old_user_releases(user, synced_releases)
    {:ok, User.get_by_name(user.name)}
  end

  defp sync_user_releases(user, release_params_list) do
    for release_params <- release_params_list do
      sync_user_release(user, release_params)
    end
  end

  defp sync_user_release(user, release_params) do
    {artists, rest_params} = Map.pop(release_params, :artists)
    artist_models = Enum.map(artists, &Artist.get_or_create/1)
    {type, result} = Release.get_struct_or_changeset(rest_params)

    change =
      case type do
        :release -> %{users: Enum.uniq([user | result.users])}
        :changeset -> %{users: [user], artists: artist_models}
      end

    result
    |> Changeset.change(change)
    |> Repo.insert_or_update!()
  end

  defp drop_old_user_releases(user, releases) do
    release_ids = Enum.reduce(releases, %MapSet{}, &MapSet.put(&2, &1.id))
    old_releases = Enum.reject(user.releases, &MapSet.member?(release_ids, &1.id))

    for release <- old_releases,
        do:
          Repo.delete!(%UserRelease{
            user_id: user.id,
            release_id: release.id
          })
  end
end
