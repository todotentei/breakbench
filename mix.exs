defmodule Breakbench.Mixfile do
  use Mix.Project

  def project do
    [
      app: :breakbench,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Breakbench.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test) do
    [
      "lib",
      "test/support",
      "test/factories",
      "test/mock_servers"
    ]
  end

  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.13.1"},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:httpoison, "~> 1.0", override: true},
      {:atomic_map, "~> 0.9"},
      {:ex_machina, "~> 2.2", only: :test},
      {:absinthe_plug, "~> 1.4.0"},
      {:absinthe_ecto, "~> 0.1.0"},
      {:wallaby, "~> 0.20.0", [runtime: false, only: :test]},
      {:timex, "~> 3.1"},
      {:geo_postgis, "~> 2.0"},
      {:verk, "~> 1.0"},
      {:flow, "~> 0.12"},
      {:benchee, "~> 0.11", only: :dev},
      {:timex_ecto, "~> 3.0"},
      {:entropy_string, "~> 1.3"},
      {:phauxth, "~> 1.2"},
      {:browser, "~> 0.1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.build": ["ecto.create", "ecto.migrate"],
      "ecto.rebuild": ["ecto.drop", "ecto.build"],
      "ecto.setup": ["ecto.build", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
