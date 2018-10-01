defmodule FuzzyCompare.MixProject do
  use Mix.Project

  @github_url "https://github.com/patrickdet/fuzzy_compare"

  def project do
    [
      app: :fuzzy_compare,
      version: "1.0.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A fuzzy string comparison library for Elixir",
      source_url: @github_url,
      homepage_url: @github_url,
      package: [
        maintainers: ["Patrick Detlefsen"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url
        }
      ],
      docs: [
        main: "FuzzyCompare"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false}
    ]
  end
end
