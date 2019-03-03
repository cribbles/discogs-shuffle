defmodule Discogs.Record do
  use Ecto.Schema
  alias Discogs.Release

  schema "record" do
    belongs_to :release, Release
    field :disc_number, :integer, null: false
    timestamps()
  end
end
