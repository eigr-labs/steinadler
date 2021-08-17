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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:ranch, "~> 2.0"},
      {:rustler, "~> 0.22"}
    ]
  end
end
