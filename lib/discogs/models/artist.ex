defmodule Discogs.Artist do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Discogs.Artist
  alias Discogs.ArtistRelease
  alias Discogs.Release
  alias Discogs.Repo

  schema "artists" do
    many_to_many :releases, Release, join_through: ArtistRelease
    field :discogs_id, :integer, null: false
    field :name, :string, null: false
    timestamps()
  end

  def get_or_create(attrs) do
    changeset = %Artist{}
    |> Changeset.change(attrs)
    |> Changeset.unique_constraint(:discogs_id)

    if artist = get_by_discogs_id(attrs.discogs_id),
      do: artist,
      else: Repo.insert(changeset) |> elem(1)
  end

  def get_by_discogs_id(discogs_id) do
    Repo.get_by(Artist, discogs_id: discogs_id)
  end
end
