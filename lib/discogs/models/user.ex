defmodule Discogs.User do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]

  alias Discogs.Repo
  alias Discogs.User
  alias Discogs.UserRelease

  schema "users" do
    has_many :user_releases, UserRelease
    field :name, :string, null: false
    timestamps()
  end

  def get_or_create_by_name(username) do
    get_by_name(username) || create_by_name(username)
  end

  def get_by_name(username) do
    query = from u in User,
      where: u.name == ^username,
      select: u,
      limit: 1
    {:ok, Repo.one(query)}
  end

  def create_by_name(username) do
    %User{name: username}
    |> Repo.insert
  end
end
