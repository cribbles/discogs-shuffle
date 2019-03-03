defmodule Discogs.UserRelease do
  use Ecto.Schema
  alias Discogs.User
  alias Discogs.Release

  schema "user_releases" do
    belongs_to :user, User
    belongs_to :release, Release
    timestamps()
  end
end
