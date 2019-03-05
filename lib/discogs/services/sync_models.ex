defmodule Discogs.SyncModels do
  alias Discogs.Release
  alias Discogs.Repo

  def sync_release_models({:ok, _user, _releases, models}) do
    {:ok, Enum.map(models.releases, &sync_release/1)}
  end

  defp sync_release({release, records}) do
    {:ok, release_model} = Repo.insert(release)
    {:ok, record_models} = sync_records(release_model, records)
    {:ok, %Release{release_model | records: record_models}}
  end

  defp sync_records(release, records) do
    build_assoc_records(release, records)
    |> create_records_transaction
    |> Repo.transaction()
  end

  defp build_assoc_records(release, records) do
    Enum.map(records, &Ecto.build_assoc(release, :records, &1))
  end

  defp create_records_transaction(records) do
    Enum.reduce(records, Ecto.Multi.new(), fn (record, multi) ->
      Ecto.Multi.insert(multi, record.disc_number, record)
    end)
  end
end
