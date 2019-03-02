defmodule Discogs.SyncReleases do
  def sync({:ok, releases}) do
    IO.inspect releases
    IO.inspect "Hello World"
  end
end
