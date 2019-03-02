defmodule Discogs.JSONFetch do
  @discogs_http_timeout_ms 15_000
  @discogs_pagination_limit 500

  def fetch_releases_by_username(username) do
    username
    |> initial_discogs_url
    |> fetch_releases_by_url
  end

  def fetch_releases_by_url(discogs_url, releases \\ []) do
    discogs_url
    |> HTTPoison.get([], [recv_timeout: @discogs_http_timeout_ms])
    |> handle_json(releases)
  end

  defp handle_json({:ok, %{status_code: 200, body: body}}, releases) do
    payload = parse_json(body)
    next_url = get_in(payload, ["pagination", "urls", "next"])
    all_releases = releases ++ get_in(payload, ["releases"])
    fetch_or_return_releases(next_url, all_releases)
  end

  defp handle_json({_, %{status_code: status_code, body: body }}, _) do
    {:error, status_code, body }
  end

  defp fetch_or_return_releases(url, releases) when is_bitstring(url) do
    fetch_releases_by_url(url, releases)
  end

  defp fetch_or_return_releases(_, releases) do
    {:ok, releases}
  end

  defp initial_discogs_url(username) do
    "https://api.discogs.com/users/"
    <> username
    <> "/collection/folders/0/releases?per_page="
    <> to_string(@discogs_pagination_limit)
  end

  defp parse_json(json) do
    Poison.Parser.parse!(json, %{})
  end
end
