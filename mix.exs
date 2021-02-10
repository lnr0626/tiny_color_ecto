defmodule TinyColorEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :tiny_color_ecto,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: """
      Ecto support for https://hexdocs.pm/tiny_color/
      """,
      package: package()
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/lnr0626/tiny_color_ecto"}
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
      {:ecto, "~> 3.4.3"},
      {:tiny_color, "~> 0.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
