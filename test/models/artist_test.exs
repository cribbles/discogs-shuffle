defmodule DiscogsTest.ArtistTest do
  alias Discogs.{Artist, Repo}
  alias Ecto.Adapters.SQL.Sandbox
  use ExUnit.Case

  @valid_attrs %{
    name: "artist-name",
    discogs_id: 15
  }

  setup do
    :ok = Sandbox.checkout(Repo)
  end

  describe "Artist.changeset/2" do
    test "is valid when the params are valid" do
      changeset = Artist.changeset(%Artist{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid when params are missing" do
      for attr <- Map.keys(@valid_attrs) do
        missing_attrs = Map.drop(@valid_attrs, [attr])
        changeset = Artist.changeset(%Artist{}, missing_attrs)
        assert !changeset.valid?
      end
    end

    test "is invalid when params are invalid" do
      changeset = Artist.changeset(%Artist{}, %{name: ""})
      assert !changeset.valid?
    end

    test "is invalid when the discogs_id is not unique" do
      discogs_id = 12
      attrs = Map.merge(@valid_attrs, %{discogs_id: discogs_id})

      insert_with_attrs = fn ->
        %Artist{} |> Artist.changeset(attrs) |> Repo.insert!()
      end

      insert_with_attrs.()
      assert_raise(Sqlite.DbConnection.Error, insert_with_attrs)
    end
  end

  describe "Artist.get_or_create/1" do
    test "creates an artist when a matching artist does not exist" do
      artist = Artist.get_or_create(@valid_attrs)
      assert %Artist{} = artist
      assert Ecto.get_meta(artist, :state) == :loaded

      for {attr, value} <- @valid_attrs do
        assert Map.get(artist, attr) == value
      end
    end

    test "returns a matching artist when one exists" do
      artist = %Artist{} |> Artist.changeset(@valid_attrs) |> Repo.insert!()
      assert artist == Artist.get_or_create(@valid_attrs)
    end
  end

  describe "Artist.get_by_discogs_id/1" do
    test "returns nil when there is no matching artist" do
      assert Artist.get_by_discogs_id(15) == nil
    end

    test "returns the artist when there is a matching artist" do
      discogs_id = 12
      attrs = Map.merge(@valid_attrs, %{discogs_id: discogs_id})
      %Artist{} |> Artist.changeset(attrs) |> Repo.insert!()
      artist = Artist.get_by_discogs_id(discogs_id)
      assert %Artist{} = artist

      for {attr, value} <- attrs do
        assert Map.get(artist, attr) == value
      end
    end
  end
end
