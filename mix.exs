defmodule Steinadler.MixProject do
  use Mix.Project

  def project do
    [
      app: :steinadler,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :retry]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cachex, "~> 3.4"},
      {:cowlib, "~> 2.9.0", override: true},
      {:flow, "~> 1.1"},
      {:gen_stage, "~> 1.1"},
      {:google_protos, "~> 0.1.0"},
      {:grpc, "~> 0.5.0-beta.1"},
      {:injectx, "~> 0.1"},
      {:jason, "~> 1.2"},
      {:joken, "~> 2.4"},
      {:qex, "~> 0.5"},
      {:libcluster, "~> 3.3"},
      {:poison, "~> 5.0"},
      {:retry, "~> 0.14"},
      {:rustler, "~> 0.22"}
    ]
  end
end
