defmodule Discogs.MixProject do
  use Mix.Project

  def project do
    [
      app: :discogs,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Discogs.Repo],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [
        :logger,
        :poison,
        :sqlite_ecto2,
        :ecto
      ],
      mod: {Discogs.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.5"},
      {:poison, "~> 3.0"},
      {:sqlite_ecto2, "~> 2.2"},
    ]
  end
end
