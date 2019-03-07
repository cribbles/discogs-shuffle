defmodule Discogs.User do
  @moduledoc """
  Ecto struct representing a Discogs user.
  """
  use Ecto.Schema
  alias Discogs.Repo
  alias Discogs.Release
  alias Discogs.User
  alias Discogs.UserRelease

  schema "users" do
    many_to_many(:releases, Release, join_through: UserRelease)
    has_many(:records, through: [:releases, :records])
    field(:name, :string, null: false)
    timestamps()
  end

  def get_or_create_by_name(username) do
    {:ok, get_by_name(username) || create_by_name(username)}
  end

  def get_by_name(username) do
    Repo.get_by(User, name: username)
  end

  def create_by_name(username) do
    %User{name: username}
    |> Repo.insert()
    |> elem(1)
  end
end
