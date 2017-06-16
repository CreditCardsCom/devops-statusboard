defmodule Dashboard.Mixfile do
  use Mix.Project

  def project do
    [app: :dashboard,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Dashboard.Application, []},
     extra_applications: [:logger, :runtime_tools, :httpoison]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cors_plug, "~> 1.2"},
      {:cowboy, "~> 1.0"},
      {:distillery, "~> 1.3", only: :dev},
      {:gettext, "~> 0.11"},
      {:httpoison, "~> 1.0"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:poison, "~> 3.1"}
    ]
  end

  defp aliases do
  end
end
