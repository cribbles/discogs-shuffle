defmodule Discogs.Models.User do
  @moduledoc """
  Ecto model representing a Discogs user.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Discogs.Models.{Release, User, UserRelease}
  alias Discogs.Repo

  schema "users" do
    many_to_many(:releases, Release, join_through: UserRelease)
    has_many(:records, through: [:releases, :records])
    field(:name, :string, null: false)
    timestamps()
  end

  @doc """
  Validates the params and returns an Ecto changeset on success.

  Name length / format validation is reflective of the validation set by
  Discogs itself.

  cf. https://bit.ly/3udL05l
  """
  @type params :: %{
          optional(:name) => String.t(),
          optional(:releases) => [%Release{}, ...]
        }
  @spec changeset(%User{}, params) :: Ecto.Changeset.t()
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name])
    |> cast_assoc(:releases)
    |> validate_required(:name)
    |> validate_length(:name, min: 3, max: 20)
    |> validate_format(:name, ~r/^[\w\.\-]+$/)
    |> unique_constraint(:name)
  end

  @doc """
  Gets or creates the `User`.
  """
  @spec get_or_create_by_name(name :: String.t()) :: %User{}
  def get_or_create_by_name(name) do
    get_by_name(name) || create_by_name(name)
  end

  @doc """
  Gets the `User` by name.
  """
  @spec get_by_name(name :: String.t()) :: %User{} | nil
  def get_by_name(name) do
    User
    |> Repo.get_by(name: name)
    |> Repo.preload(:releases)
    |> Repo.preload(releases: :artists)
    |> Repo.preload(:records)
  end

  @doc """
  Creates the `User`.
  """
  @spec create_by_name(name :: String.t()) :: %User{}
  def create_by_name(name) do
    %User{}
    |> User.changeset(%{name: name})
    |> Repo.insert!()
    |> Repo.preload(:releases)
    |> Repo.preload(releases: :artists)
    |> Repo.preload(:records)
  end
end
