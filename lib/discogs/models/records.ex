defmodule Discogs.Record do
  use Ecto.Schema
  alias Discogs.Release

  schema "records" do
    belongs_to :release, Release
    field :disc_number, :integer, null: false
    timestamps()
  end
end
