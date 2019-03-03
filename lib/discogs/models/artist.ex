defmodule Discogs.Artist do
  use Ecto.Schema
  alias Discogs.ArtistRelease

  schema "artists" do
    has_many :artist_releases, ArtistRelease
    field :discogs_id, :integer, null: false
    field :name, :string, null: false
    timestamps()
  end
end
