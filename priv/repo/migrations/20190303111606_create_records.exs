defmodule Discogs.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table :records do
      add :release_id, references(:releases), null: false
      add :disc_number, :integer, null: false
      timestamps()
    end

    create unique_index(:records, [:release_id, :disc_number])
  end
end
