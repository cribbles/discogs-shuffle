defmodule Discogs.Application do
  @moduledoc """
  Application entry point.

  cf. https://hexdocs.pm/elixir/1.12/Application.html
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Discogs.Repo
    ]

    opts = [strategy: :one_for_one, name: Discogs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
