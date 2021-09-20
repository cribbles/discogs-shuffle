defmodule DiscogsTest.ModelsTest.UserTest do
  alias Discogs.Models.User
  alias Discogs.Repo
  alias Ecto.Adapters.SQL.Sandbox
  use ExUnit.Case

  @valid_attrs %{
    name: "discogs-user"
  }

  setup do
    :ok = Sandbox.checkout(Repo)
  end

  describe "User.changeset/2" do
    test "is valid when the params are valid" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid when the params are missing" do
      for attr <- Map.keys(@valid_attrs) do
        missing_attrs = Map.drop(@valid_attrs, [attr])
        changeset = User.changeset(%User{}, missing_attrs)
        assert !changeset.valid?
      end
    end

    test "is invalid when the params are invalid" do
      changeset = User.changeset(%User{}, %{name: ""})
      assert !changeset.valid?
    end

    test "is invalid when the name is not unique" do
      username = "foo"
      attrs = Map.merge(@valid_attrs, %{name: username})

      insert_with_attrs = fn ->
        %User{} |> User.changeset(attrs) |> Repo.insert!()
      end

      insert_with_attrs.()
      assert_raise(Sqlite.DbConnection.Error, insert_with_attrs)
    end
  end

  describe "User.get_or_create_by_name/1" do
    test "gets or creates the user by their username" do
      user_1 = User.get_or_create_by_name("discogs-user")
      user_2 = User.get_or_create_by_name("discogs-user")
      assert user_1 == user_2
    end
  end

  describe "User.get_by_name/1" do
    test "returns nil when there is no matching user" do
      assert User.get_by_name("discogs-user") == nil
    end

    test "returns the user when there is a matching user" do
      User.create_by_name("discogs-user")
      user = User.get_by_name("discogs-user")
      assert %User{} = user
      assert Ecto.get_meta(user, :state) == :loaded
      assert user.name == "discogs-user"
    end
  end

  describe "User.create_by_name/1" do
    test "creates the user" do
      user = User.create_by_name("discogs-user")
      assert %User{} = user
      assert Ecto.get_meta(user, :state) == :loaded
      assert user.name == "discogs-user"
    end

    test "raises when the user already exists" do
      User.create_by_name("discogs-user")

      assert_raise Sqlite.DbConnection.Error, fn ->
        User.create_by_name("discogs-user")
      end
    end

    test "raises when the name is invalid" do
      assert_raise Ecto.InvalidChangesetError, fn ->
        User.create_by_name("")
      end
    end
  end
end
