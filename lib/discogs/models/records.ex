defmodule Discogs.Record do
  @moduledoc """
  Ecto struct representing a record belonging to a Discogs release.

  This is not a first-class object in Discogs's data model. What this allows us
  to do is to join over from User -> Release -> Record and pick out a random
  sampling of _specific records_ in a user's collection (for example, disc 2
  of a 2xLP set).
  """
  use Ecto.Schema
  alias Discogs.Release

  schema "records" do
    belongs_to(:release, Release)
    field(:disc_number, :integer, null: false)
    timestamps()
  end
end
