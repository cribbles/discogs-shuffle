defmodule Discogs.Repo.Migrations.CreateArtistReleases do
  use Ecto.Migration

  def change do
    create table :artist_releases do
      add :artist_id, references(:artists), null: false
      add :release_id, references(:releases), null: false
      timestamps()
    end

    create unique_index(:artist_releases, [:artist_id, :release_id])
  end
end
