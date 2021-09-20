defmodule Discogs.Models.ArtistRelease do
  @moduledoc """
  Ecto model representing a Discogs artist-to-release relationship.
  """
  use Ecto.Schema
  alias Discogs.Models.{Artist, Release}

  schema "artist_releases" do
    belongs_to(:artist, Artist)
    belongs_to(:release, Release)
    timestamps()
  end
end
