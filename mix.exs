defmodule Steinadler.MixProject do
  use Mix.Project

  @app :steinadler
  @version "0.1.0"
  @source_url "https://github.com/eigr-labs/steinadler"

  def project do
    [
      app: @app,
      version: @version,
      description: "Steinadler is a high-level alternative to Erlang Distribution",
      source_url: @source_url,
      homepage_url: "https://eigr.io/",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["Apache-2.0"],
      links: %{GitHub: @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatter_opts: [gfm: true],
      extras: [
        "README.md"
      ]
    ]
  end

  defp deps do
    [
      {:protobuf, "~> 0.10"},
      {:gnat, "~> 1.6"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
