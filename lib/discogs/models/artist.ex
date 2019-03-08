defmodule Discogs.Artist do
  @moduledoc """
  Ecto struct representing a Discogs artist.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Discogs.{Artist, ArtistRelease, Release, Repo}

  schema "artists" do
    many_to_many(:releases, Release, join_through: ArtistRelease)
    has_many(:records, through: [:releases, :records])
    field(:discogs_id, :integer, null: false)
    field(:name, :string, null: false)
    timestamps()
  end

  def changeset(artist, params \\ %{}) do
    artist
    |> cast(params, [:discogs_id, :name])
    |> cast_assoc(:releases)
    |> validate_required(:discogs_id)
    |> validate_required(:name)
    |> unique_constraint(:discogs_id)
    |> validate_length(:name, min: 1)
  end

  def get_or_create(%{discogs_id: discogs_id} = map_with_attrs) do
    if artist = get_by_discogs_id(discogs_id),
      do: artist,
      else: %Artist{} |> changeset(map_with_attrs) |> Repo.insert() |> elem(1)
  end

  def get_by_discogs_id(discogs_id) do
    Repo.get_by(Artist, discogs_id: discogs_id)
  end
end
