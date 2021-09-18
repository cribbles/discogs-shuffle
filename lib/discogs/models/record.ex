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
  import Ecto.Changeset

  schema "records" do
    belongs_to(:release, Release)
    has_many(:artists, through: [:release, :artists])
    field(:disc_number, :integer, null: false)
    timestamps()
  end

  def changeset(record, params \\ %{}) do
    record
    |> cast(params, [:disc_number])
    |> cast_assoc(:release)
    |> validate_required(:disc_number)
    |> assoc_constraint(:release)
    |> unique_constraint(:disc_number,
      name: :records_disc_number_release_id_index
    )
  end

  def format_name(%{disc_number: disc_number, release: release}, formatter) do
    release_name = formatter.(release)

    if length(release.records) > 1,
      do: "#{release_name} (disc #{disc_number})",
      else: release_name
  end
end
