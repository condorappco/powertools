defmodule Powertools.MixProject do
  use Mix.Project

  def project do
    [
      app: :powertools,
      description: "A @condorappco library for commonly used utility functions",
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  defp package do
    [
      maintainers: ["Tres Trantham"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/condorappco/powertools"},
      files: ~w(lib mix.exs README.md .formatter.exs)
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
