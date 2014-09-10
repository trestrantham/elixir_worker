defmodule ElixirWorker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_worker,
      version: "0.0.1",
      elixir: "~> 1.0.0-rc2",
      deps: deps
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger],
      mode: {ElixirWorker, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:exredis, "~> 0.1"},
      {:jazz, "~> 0.2"}
    ]
  end
end
