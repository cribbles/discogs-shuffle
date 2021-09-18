defmodule Discogs.MixProject do
  use Mix.Project

  def project do
    [
      app: :discogs,
      version: "0.1.0",
      elixir: "~> 1.12.3",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Discogs.Repo],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [
        :hackney,
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
      {:httpoison, "~> 1.8"},
      {:poison, "~> 3.0"},
      {:sqlite_ecto2, "~> 2.2"},
      {:credo, "~> 1.5.6", only: [:dev, :test], runtime: false}
    ]
  end
end
