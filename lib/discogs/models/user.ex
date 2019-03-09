defmodule Discogs.User do
  @moduledoc """
  Ecto struct representing a Discogs user.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Discogs.{Release, Repo, User, UserRelease}

  schema "users" do
    many_to_many(:releases, Release, join_through: UserRelease)
    has_many(:records, through: [:releases, :records])
    field(:name, :string, null: false)
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name])
    |> cast_assoc(:releases)
    |> validate_required(:name)
    |> validate_length(:name, min: 1)
    |> unique_constraint(:name)
  end

  def get_or_create_by_name(username) do
    get_by_name(username) || create_by_name(username)
  end

  def get_by_name(username) do
    User
    |> Repo.get_by(name: username)
    |> Repo.preload(:releases)
    |> Repo.preload(releases: :artists)
    |> Repo.preload(:records)
  end

  def create_by_name(username) do
    %User{}
    |> User.changeset(%{name: username})
    |> Repo.insert!()
    |> Repo.preload(:releases)
    |> Repo.preload(releases: :artists)
    |> Repo.preload(:records)
  end
end
