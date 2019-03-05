defmodule Discogs.UserRelease do
  use Ecto.Schema
  alias Discogs.Release
  alias Discogs.User

  schema "user_releases" do
    belongs_to :user, User
    belongs_to :release, Release
    timestamps()
  end
end
