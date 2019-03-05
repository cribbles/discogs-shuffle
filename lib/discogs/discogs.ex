defmodule Discogs.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Discogs.Repo,
    ]

    opts = [strategy: :one_for_one, name: Discogs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
