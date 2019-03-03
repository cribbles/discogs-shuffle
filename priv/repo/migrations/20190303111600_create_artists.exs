defmodule Discogs.Repo.Migrations.CreateArtists do
  use Ecto.Migration

  def change do
    create table :artists do
      add :discogs_id, :integer, null: false
      add :name, :string, null: false
      timestamps()
    end

    create unique_index(:artists, [:discogs_id])
  end
end
