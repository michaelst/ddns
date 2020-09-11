defmodule DDNS.MixProject do
  use Mix.Project

  def project do
    [
      app: :ddns,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DDNS.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2.0"},
      {:tesla, "~> 1.3.0"}
    ]
  end
end
