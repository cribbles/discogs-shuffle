defmodule Discogs.UserRelease do
  @moduledoc """
  Ecto struct representing a Discogs user-to-release relationship.
  """
  use Ecto.Schema
  alias Discogs.{Release, User}

  schema "user_releases" do
    belongs_to(:user, User)
    belongs_to(:release, Release)
    timestamps()
  end
end
