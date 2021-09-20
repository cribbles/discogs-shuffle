defmodule Discogs.Repo do
  @moduledoc """
  Defines the Ecto repository.

  cf. https://hexdocs.pm/ecto/Ecto.Repo.html
  """

  use Ecto.Repo,
    otp_app: :discogs,
    adapter: Sqlite.Ecto2
end
