defmodule Discogs.Release do
  use Ecto.Schema
  alias Discogs.Record

  schema "releases" do
    has_many :records, Record
    field :discogs_id, :integer, null: false
    field :name, :string, null: false
    timestamps()
  end
end
