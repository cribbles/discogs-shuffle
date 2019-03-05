defmodule Discogs.SyncModels do
  alias Discogs.Repo
  alias Discogs.Release

  def sync_release_models({:ok, _user, _releases, models}) do
    Repo.insert_all(Release, models.releases)
    |> IO.inspect
  end

  # def insert_artists(models) do
  #   Repo.insert_all(Release, models.artists)
  # end
  #
  # def insert_releases(models) do
  #   Repo.insert_all(Release, models.releases)
  # end
end
