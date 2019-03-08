defmodule DiscogsTest.ReleaseTest do
  alias Discogs.{Release, Repo}
  alias Ecto.{Adapters.SQL.Sandbox, Changeset}
  use ExUnit.Case

  @valid_attrs %{
    name: "record-name",
    discogs_id: 15
  }

  setup do
    :ok = Sandbox.checkout(Repo)
  end

  describe "Release.changeset/2" do
    test "is valid when the params are valid" do
      changeset = Release.changeset(%Release{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid when params are missing" do
      for attr <- Map.keys(@valid_attrs) do
        missing_attrs = Map.drop(@valid_attrs, [attr])
        changeset = Release.changeset(%Release{}, missing_attrs)
        assert !changeset.valid?
      end
    end

    test "is invalid when params are invalid" do
      changeset = Release.changeset(%Release{}, %{name: ""})
      assert !changeset.valid?
    end

    test "is invalid when the discogs_id is not unique" do
      discogs_id = 12
      attrs = Map.merge(@valid_attrs, %{discogs_id: discogs_id})

      insert_with_attrs = fn ->
        %Release{} |> Release.changeset(attrs) |> Repo.insert!()
      end

      insert_with_attrs.()
      assert_raise(Sqlite.DbConnection.Error, insert_with_attrs)
    end
  end

  describe "Release.get_struct_or_changeset/1" do
    test "returns a changeset when a matching release does not exist" do
      {type, changeset} = Release.get_struct_or_changeset(@valid_attrs)
      assert type == :changeset
      assert %Changeset{} = changeset

      for {attr, value} <- @valid_attrs do
        assert Map.get(changeset.changes, attr) == value
      end
    end

    test "returns a matching release when one exists" do
      %Release{} |> Release.changeset(@valid_attrs) |> Repo.insert!()
      {type, release} = Release.get_struct_or_changeset(@valid_attrs)
      assert type == :release
      assert %Release{} = release

      for {attr, value} <- @valid_attrs do
        assert Map.get(release, attr) == value
      end
    end
  end

  describe "Release.get_by_discogs_id/1" do
    test "returns nil when there is no matching release" do
      assert Release.get_by_discogs_id(15) == nil
    end

    test "returns the release when there is a matching release" do
      discogs_id = 12
      attrs = Map.merge(@valid_attrs, %{discogs_id: discogs_id})
      %Release{} |> Release.changeset(attrs) |> Repo.insert!()
      release = Release.get_by_discogs_id(discogs_id)
      assert %Release{} = release

      for {attr, value} <- attrs do
        assert Map.get(release, attr) == value
      end
    end
  end
end
