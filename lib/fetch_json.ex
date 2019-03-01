defmodule Discogs.JSONFetch do
  def fetch(username) do
    username
    |> discogs_url
    |> HTTPoison.get
    |> handle_json
  end

  defp handle_json({:ok, %{status_code: 200, body: body}}) do
    {:ok, parse_json(body)}
  end

  defp handle_json({_, %{status_code: status_code, body: body }}) do
    {:error, status_code, body }
  end

  defp discogs_url(username) do
    "https://api.discogs.com/users/#{username}/collection/folders/0/releases"
  end

  defp parse_json(json) do
    Poison.Parser.parse!(json, %{})
  end
end

