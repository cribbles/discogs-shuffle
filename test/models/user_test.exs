defmodule DiscogsTest.UserTest do
  alias Discogs.{Repo, User}
  use ExUnit.Case

  @valid_attrs %{
    name: "discogs-user"
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "User.changeset/2" do
    test "is valid when the params are valid" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid when the params are invalid" do
      changeset = User.changeset(%User{}, %{})
      assert !changeset.valid?
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
      %User{id: id, name: name} = User.get_by_name("discogs-user")
      assert id == 1
      assert name == "discogs-user"
    end
  end

  describe "User.create_by_name/1" do
    test "creates the user" do
      %User{id: id, name: name} = User.create_by_name("discogs-user")
      assert id == 1
      assert name == "discogs-user"
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
