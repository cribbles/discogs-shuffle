defmodule Discogs.Repo.Migrations.CreateReleases do
  use Ecto.Migration

  def change do
    create table :releases do
      add :discogs_id, :integer, null: false
      add :name, :string, null: false
      timestamps()
    end

    create unique_index(:releases, [:discogs_id])
  end
end
