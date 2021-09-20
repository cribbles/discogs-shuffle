defmodule Discogs.Services.JSONFetch do
  @moduledoc """
  Fetches release data from the Discogs API.
  """
  @discogs_http_timeout_ms 15_000
  @discogs_pagination_limit 500

  alias Discogs.Models.User

  @typedoc "Discogs JSON API release payload properties"
  @type release_json :: %{optional(any) => any}
  @type success :: {:ok, [release_json]}
  @type http_error :: {:error, status_code :: pos_integer(), body :: binary()}
  @type result :: success | http_error

  @doc """
  Fetches a `User`'s release data from the Discogs API.

  If the responses are paginated, continually fetches to the last page,
  returning the stitched-up payload.

  This does not take rate limiting into account and will probably fail if
  used to fetch from a user with many thousands of releases.
  """
  @spec fetch_releases(user :: %User{}) :: result
  def fetch_releases(%User{name: name}) do
    do_fetch_releases({:username, name})
  end

  defp do_fetch_releases({:username, username}) do
    discogs_url = initial_discogs_url(username)
    do_fetch_releases({:url, discogs_url})
  end

  defp do_fetch_releases({:url, url}, releases \\ []) do
    url
    |> HTTPoison.get([], recv_timeout: @discogs_http_timeout_ms)
    |> handle_json(releases)
  end

  defp handle_json({:ok, %{status_code: 200, body: body}}, releases) do
    payload = parse_json(body)
    next_url = get_in(payload, ["pagination", "urls", "next"])
    all_releases = releases ++ get_in(payload, ["releases"])

    if next_url,
      do: do_fetch_releases({:url, next_url}, all_releases),
      else: {:ok, all_releases}
  end

  defp handle_json({_, %{status_code: status_code, body: body}}, _) do
    {:error, status_code, body}
  end

  defp initial_discogs_url(username) do
    "https://api.discogs.com/users/" <>
      username <>
      "/collection/folders/0/releases?per_page=" <>
      to_string(@discogs_pagination_limit)
  end

  defp parse_json(json) do
    Poison.Decoder.decode(json, %{}) |> Poison.Parser.parse!()
  end
end
