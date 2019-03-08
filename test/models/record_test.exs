defmodule DiscogsTest.RecordTest do
  alias Discogs.{Record, Release, Repo}
  alias Ecto.Adapters.SQL.Sandbox
  use ExUnit.Case

  @valid_attrs %{
    disc_number: 1,
    release: %{
      name: "release-name",
      discogs_id: 15
    }
  }

  @virtual_attrs MapSet.new([:release])

  setup do
    :ok = Sandbox.checkout(Repo)
  end

  describe "Record.changeset/2" do
    test "is valid when the params are valid" do
      changeset = Record.changeset(%Record{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid when the params are missing" do
      non_virtual_attrs =
        @valid_attrs
        |> Map.keys()
        |> MapSet.new()
        |> MapSet.difference(@virtual_attrs)

      for attr <- non_virtual_attrs do
        missing_attrs = Map.drop(@valid_attrs, [attr])
        changeset = Record.changeset(%Record{}, missing_attrs)
        assert !changeset.valid?
      end
    end

    test "is invalid when the disc number / release combo is not unique" do
      insert_with_attrs = fn ->
        %Record{} |> Record.changeset(@valid_attrs) |> Repo.insert!()
      end

      insert_with_attrs.()
      assert_raise(Sqlite.DbConnection.Error, insert_with_attrs)
    end
  end
end
