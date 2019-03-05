defmodule Discogs.Helpers do
  def pick(map, values) do
    Enum.map(map, &(Map.take(&1, values)))
  end
end
