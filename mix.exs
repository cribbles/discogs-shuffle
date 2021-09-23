defmodule Discogs.MixProject do
  use Mix.Project

  @scm_url "https://github.com/cribbles/discogs-shuffle"

  def project do
    [
      app: :discogs,
      version: "0.2.1",
      elixir: "~> 1.12.3",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Discogs.CLI],
      description: description(),
      package: package(),
      deps: deps(),
      name: "discogs_shuffle",
      source_url: "https://github.com/cribbles/discogs-shuffle",
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  def description do
    """
    A library that stores Discogs user collections to a local database
    and allows interaction via Ecto wrappers.
    """
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

  defp package do
    [
      maintainers: ["Chris Sloop"],
      licenses: ["MIT"],
      links: %{"GitHub" => @scm_url},
      exclude_patterns: [
        "priv/esqlite3_nif.so",
        "priv/priv"
      ]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:poison, "~> 3.0"},
      {:sqlite_ecto2, "~> 2.2"},
      {:credo, "~> 1.5.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.25", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end
end
