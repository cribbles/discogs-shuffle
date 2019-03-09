defmodule Discogs.Release do
  @moduledoc """
  Ecto struct representing a Discogs release.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Discogs.{
    Artist,
    ArtistRelease,
    Record,
    Release,
    Repo,
    User,
    UserRelease
  }

  schema "releases" do
    has_many(:records, Record)
    many_to_many(:artists, Artist, join_through: ArtistRelease)
    many_to_many(:users, User, join_through: UserRelease)
    field(:discogs_id, :integer, null: false)
    field(:name, :string, null: false)
    timestamps()
  end

  def changeset(release, params \\ %{}) do
    release
    |> cast(params, [:discogs_id, :name])
    |> cast_assoc(:artists)
    |> cast_assoc(:records)
    |> cast_assoc(:users)
    |> validate_required(:discogs_id)
    |> validate_required(:name)
    |> unique_constraint(:discogs_id)
    |> validate_length(:name, min: 1)
  end

  def get_struct_or_changeset(%{discogs_id: discogs_id} = map_with_attrs) do
    if release = get_by_discogs_id(discogs_id),
      do: {:release, release},
      else: {:changeset, changeset(%Release{}, map_with_attrs)}
  end

  def get_by_discogs_id(discogs_id) do
    Release
    |> Repo.get_by(discogs_id: discogs_id)
    |> Repo.preload(:users)
  end

  def format_name(%{name: release_name} = release) do
    "#{format_artist_names(release)} - #{release_name}"
  end

  defp format_artist_names(%{artists: artists}) do
    artists
    |> Enum.map(& &1.name)
    |> Enum.join(" / ")
  end
end
