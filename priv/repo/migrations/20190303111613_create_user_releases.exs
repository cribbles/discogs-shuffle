defmodule Discogs.Repo.Migrations.CreateUserReleases do
  use Ecto.Migration

  def change do
    create table :user_releases do
      add :user_id, references(:users), null: false
      add :release_id, references(:releases), null: false
      timestamps()
    end

    create unique_index(:user_releases, [:user_id, :release_id])
  end
end
