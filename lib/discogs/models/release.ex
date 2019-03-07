defmodule Discogs.Release do
  @moduledoc """
  Ecto struct representing a Discogs release.
  """
  use Ecto.Schema
  alias Discogs.Artist
  alias Discogs.ArtistRelease
  alias Discogs.Release
  alias Discogs.Record
  alias Discogs.Repo
  alias Discogs.User
  alias Discogs.UserRelease
  alias Ecto.Changeset

  schema "releases" do
    has_many(:records, Record)
    many_to_many(:artists, Artist, join_through: ArtistRelease)
    many_to_many(:users, User, join_through: UserRelease)
    field(:discogs_id, :integer, null: false)
    field(:name, :string, null: false)
    timestamps()
  end

  def get_struct_or_changeset(map_with_attrs) do
    changeset =
      %Release{}
      |> Changeset.change(map_with_attrs)
      |> Changeset.unique_constraint(:discogs_id)

    if release = get_by_discogs_id(map_with_attrs.discogs_id),
      do: {:release, release},
      else: {:changeset, changeset}
  end

  def get_by_discogs_id(discogs_id) do
    Release
    |> Repo.get_by(discogs_id: discogs_id)
    |> Repo.preload(:users)
  end
end
