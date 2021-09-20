defmodule Discogs.Models.Release do
  @moduledoc """
  Ecto model representing a Discogs release.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Discogs.Models.{
    Artist,
    ArtistRelease,
    Record,
    Release,
    User,
    UserRelease
  }

  alias Discogs.Repo

  schema "releases" do
    has_many(:records, Record)
    many_to_many(:artists, Artist, join_through: ArtistRelease)
    many_to_many(:users, User, join_through: UserRelease)
    field(:discogs_id, :integer, null: false)
    field(:name, :string, null: false)
    timestamps()
  end

  @doc """
  Validates the params and returns an Ecto changeset on success.
  """
  @type params :: %{
          optional(:artists) => [%Artist{}, ...],
          optional(:discogs_id) => pos_integer,
          optional(:name) => String.t(),
          optional(:records) => [%Record{}, ...],
          optional(:users) => [%User{}, ...]
        }
  @spec changeset(%Release{}, params) :: Ecto.Changeset.t()
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

  @doc """
  Gets the `Release` or an Ecto changeset ready for insert.
  """
  @type release :: {:release, %Release{}}
  @type changeset :: {:changeset, Ecto.Changeset.t()}
  @type result :: release | changeset
  @spec get_struct_or_changeset(params) :: result
  def get_struct_or_changeset(%{discogs_id: discogs_id} = params) do
    if release = get_by_discogs_id(discogs_id),
      do: {:release, release},
      else: {:changeset, changeset(%Release{}, params)}
  end

  @doc """
  Gets the `Release` by discogs id.
  """
  @spec get_by_discogs_id(any) :: %Release{} | nil
  def get_by_discogs_id(discogs_id) do
    Release
    |> Repo.get_by(discogs_id: discogs_id)
    |> Repo.preload(:users)
  end

  @doc """
  Formats the `Release` name for consumption by the `Discogs.Repo` (or
  elsewhere).

  TODO: This should be done by implementing String.Chars.

  cf. https://elixirschool.com/en/lessons/advanced/protocols/
  """
  @spec format_name(%Release{}) :: String.t()
  def format_name(%Release{name: release_name} = release) do
    "#{format_artist_names(release)} - #{release_name}"
  end

  defp format_artist_names(%{artists: artists}) do
    artists
    |> Enum.map(& &1.name)
    |> Enum.join(" / ")
  end
end
