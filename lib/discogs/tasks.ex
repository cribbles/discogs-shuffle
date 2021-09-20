defmodule Discogs.Tasks do
  @moduledoc """
  Namespace for common application tasks.
  """

  alias Discogs.Models.{Record, User}
  alias Discogs.Repo
  alias Discogs.Services.{JSONFetch, JSONSanitize, SyncUserCollection}

  @doc """
  Fetches a user's collection from Discogs, persists all associated models
  to the local db and updates the user's collection if had been stored
  previously.
  """
  @type result :: :ok | JSONFetch.http_error()
  @spec sync_collection(username :: String.t()) :: result
  def sync_collection(username) do
    user = User.get_or_create_by_name(username)
    result = JSONFetch.fetch_releases(user)

    case JSONFetch.fetch_releases(user) do
      {:ok, json} -> do_sync_collection(json, user)
      _ -> result
    end
  end

  @doc """
  Shuffles records a user's collection, returning n = `num_records`.
  """
  @spec shuffle_collection(
          username :: String.t(),
          num_records :: pos_integer
        ) :: [%Record{}]
  def shuffle_collection(username, num_records) do
    username
    |> User.get_or_create_by_name()
    |> Map.get(:records)
    |> Enum.shuffle()
    |> Enum.take(num_records)
    |> Repo.preload([:release, release: [:records, :artists]])
  end

  defp do_sync_collection(json, user) do
    json
    |> JSONSanitize.get_release_params()
    |> SyncUserCollection.sync(user)

    :ok
  end
end
