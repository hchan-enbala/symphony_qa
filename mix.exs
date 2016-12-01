defmodule SymphonyQA.Mixfile do
  use Mix.Project

  def project do
    [app: :symphony_qa,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     aliases: aliases,
     elixirc_paths: elixirc_paths(Mix.env)]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :postgrex, :ecto]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:hound, ">= 0.0.0"},
     {:postgrex, ">= 0.0.0"},
     {:ecto, "~> 2.0"}
    ]

  end

  defp aliases do
    [c: "compile",
     hello: &hello/1,
     all: ["compile", &hello/1]]
  end

  defp hello(_) do
    Mix.shell.info "Hello world"
    Mix.shell.print_app()
    shell = Mix.shell
    Mix.shell.info shell
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
