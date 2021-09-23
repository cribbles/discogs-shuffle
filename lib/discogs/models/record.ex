defmodule Discogs.Models.Record do
  @moduledoc """
  Ecto model representing a record belonging to a Discogs release.

  This is not a first-class object in Discogs's data model. What this allows us
  to do is to join over from `User` -> `Release` -> `Record` and pick out a
  sampling of _specific records_ in a user's collection at random (for example,
  disc 2 of a 2xLP set).

  See `Discogs.Tasks.shuffle_collection/2` for example usage.
  """
  use Ecto.Schema
  alias Discogs.Models.{Record, Release}
  import Ecto.Changeset

  schema "records" do
    belongs_to(:release, Release)
    has_many(:artists, through: [:release, :artists])
    field(:disc_number, :integer, null: false)
    timestamps()
  end

  @doc """
  Validates the params and returns an Ecto changeset on success.
  """
  @type params :: %{
          optional(:disc_number) => String.t(),
          optional(:release_id) => pos_integer
        }
  @spec changeset(%Record{}, params) :: Ecto.Changeset.t()
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

  @doc """
  Formats the `Record` name for consumption by the `Discogs.Repo` (or
  elsewhere).

  If the record is part of a 2+xLP set, appends the disc number; else delegates
  to the release name.

  TODO: This should be done by implementing `String.Chars`.

  cf. https://elixirschool.com/en/lessons/advanced/protocols/

  This would allow us to:
  1. simply call the stringified value of the release, rather than passing around
     a formatter
  2. consume the stringfied value of the record similarly elsewhere (i.e., via
     simple interpolation without a method call).

  This works similarly to defining `#to_s` in Ruby.
  """
  @spec format_name(%Record{}, fun) :: String.t()
  def format_name(
        %Record{disc_number: disc_number, release: release},
        formatter
      ) do
    release_name = formatter.(release)

    if length(release.records) > 1,
      do: "#{release_name} (disc #{disc_number})",
      else: release_name
  end
end
