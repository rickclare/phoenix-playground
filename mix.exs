defmodule Playground.MixProject do
  use Mix.Project

  def project do
    [
      app: :playground,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [
        credo: :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Playground.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # {:phoenix, "~> 1.7.14"},
      {:phoenix, github: "phoenixframework/phoenix", override: true},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      #
      # TODO bump on release to {:phoenix_live_view, "~> 1.0.0"},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view", override: true},
      #
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:bun, "~> 1.3", runtime: Mix.env() in [:dev, :e2e]},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.5",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:phoenix_bakery, "~> 0.1", runtime: false},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:credo, "~> 1.7.7", only: [:dev, :test], runtime: false},
      {:styler, "~> 1.1", only: [:dev, :test], runtime: false},
      {:tailwind_formatter, "~> 0.4.0", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.migrate": ["ecto.migrate", "ecto.dump --quiet"],
      "ecto.rollback": ["ecto.rollback", "ecto.dump --quiet"],
      "ecto.setup": ["ecto.create", "ecto.load", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "assets.setup": [
        "bun.install --if-missing",
        "cmd 'bun --silent install'"
      ],
      "assets.build": [
        "bun css",
        "bun js"
      ],
      "assets.setup_deploy": [
        "bun.install --if-missing",
        "cmd 'bun install --production --frozen-lockfile'"
      ],
      "assets.deploy": [
        "bun css --minify",
        "bun js --minify",
        "phx.digest"
      ],
      test:
        Enum.filter(
          [
            "ecto.create --quiet",
            "ecto.load --quiet --skip-if-loaded",
            !System.get_env("CI") && "ecto.migrate --quiet",
            "test"
          ],
          &is_binary/1
        ),
      "dev.checks": [
        "format --dry-run --check-formatted",
        "gettext.extract --check-up-to-date",
        "compile --warnings-as-errors --all-warnings",
        "credo --all --format=oneline --min-priority=low",
        # "dialyzer --quiet",
        "cmd 'bun --silent install'",
        ~s{cmd 'bun --bun prettier --log-level=silent --check --ignore-unknown "**"'},
        "cmd 'bun --bun stylelint assets/css/**/*.css'",
        "cmd 'bun --bun eslint'"
        # "cmd 'bun --bun tsc --noEmit --project tsconfig.json'"
      ]
    ]
  end
end
