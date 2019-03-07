defmodule Discogs.ArtistRelease do
  @moduledoc """
  Ecto struct representing a Discogs artist-to-release relationship.
  """
  use Ecto.Schema
  alias Discogs.Artist
  alias Discogs.Release

  schema "artist_releases" do
    belongs_to(:artist, Artist)
    belongs_to(:release, Release)
    timestamps()
  end
end
