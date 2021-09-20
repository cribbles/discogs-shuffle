defmodule Discogs.Models.Artist do
  @moduledoc """
  Ecto model representing a Discogs artist.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Discogs.Models.{Artist, ArtistRelease, Release}
  alias Discogs.Repo

  schema "artists" do
    many_to_many(:releases, Release, join_through: ArtistRelease)
    has_many(:records, through: [:releases, :records])
    field(:discogs_id, :integer, null: false)
    field(:name, :string, null: false)
    timestamps()
  end

  @doc """
  Validates the params and returns an Ecto changeset on success.
  """
  @type params :: %{
          optional(:discogs_id) => pos_integer,
          optional(:name) => String.t(),
          optional(:releases) => [%Release{}, ...]
        }
  @spec changeset(%Artist{}, params) :: Ecto.Changeset.t()
  def changeset(artist, params \\ %{}) do
    artist
    |> cast(params, [:discogs_id, :name])
    |> cast_assoc(:releases)
    |> validate_required(:discogs_id)
    |> validate_required(:name)
    |> unique_constraint(:discogs_id)
    |> validate_length(:name, min: 1)
  end

  @doc """
  Gets or creates the `Artist`.
  """
  @spec get_or_create(params) :: %Artist{}
  def get_or_create(%{discogs_id: discogs_id} = params) do
    if artist = get_by_discogs_id(discogs_id),
      do: artist,
      else: create(params)
  end

  @doc """
  Gets the `Artist` by discogs id.
  """
  @spec get_by_discogs_id(any) :: %Artist{} | nil
  def get_by_discogs_id(discogs_id) do
    Repo.get_by(Artist, discogs_id: discogs_id)
  end

  @doc """
  Creates the `Artist`.
  """
  @spec create(params) :: %Artist{}
  def create(params) do
    changeset(%Artist{}, params) |> Repo.insert() |> elem(1)
  end
end
