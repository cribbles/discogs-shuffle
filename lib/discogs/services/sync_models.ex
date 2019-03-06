defmodule Discogs.SyncModels do
  alias Discogs.Artist
  alias Discogs.Record
  alias Discogs.Release
  alias Discogs.Repo
  alias Discogs.User
  alias Ecto.Changeset
  alias Ecto.Multi

  def sync_models({:ok, user, releases}) do
    for release <- releases, do: sync_release(user, release)
  end

  defp sync_release(user, releases) do
    {artists, rest_attrs} = Map.pop(releases, :artists)
    artist_models = Enum.map(artists, &Artist.get_or_create/1)
    {status, struct_or_changeset} = Release.get_struct_or_changeset(rest_attrs)
    change = case status do
      :release -> %{users: [user | struct_or_changeset.users]}
      :changeset -> %{users: [user], artists: artist_models}
    end
    Changeset.change(struct_or_changeset, change) |> Repo.insert_or_update!
  end
end
