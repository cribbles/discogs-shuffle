defmodule Discogs.Artist do
  @moduledoc """
  Ecto struct representing a Discogs artist.
  """
  use Ecto.Schema
  alias Ecto.Changeset
  alias Discogs.Artist
  alias Discogs.ArtistRelease
  alias Discogs.Release
  alias Discogs.Repo

  schema "artists" do
    many_to_many(:releases, Release, join_through: ArtistRelease)
    field(:discogs_id, :integer, null: false)
    field(:name, :string, null: false)
    timestamps()
  end

  def get_or_create(map_with_attrs) do
    changeset =
      %Artist{}
      |> Changeset.change(map_with_attrs)
      |> Changeset.unique_constraint(:discogs_id)

    if artist = get_by_discogs_id(map_with_attrs.discogs_id),
      do: artist,
      else: changeset |> Repo.insert() |> elem(1)
  end

  def get_by_discogs_id(discogs_id) do
    Repo.get_by(Artist, discogs_id: discogs_id)
  end
end
