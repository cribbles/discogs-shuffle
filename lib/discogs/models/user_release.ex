defmodule Discogs.Models.UserRelease do
  @moduledoc """
  Ecto model representing a Discogs user-to-release relationship.
  """
  use Ecto.Schema
  alias Discogs.Models.{Release, User}

  schema "user_releases" do
    belongs_to(:user, User)
    belongs_to(:release, Release)
    timestamps()
  end
end
