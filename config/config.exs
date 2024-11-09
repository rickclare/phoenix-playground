# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :playground,
  ecto_repos: [Playground.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :playground, PlaygroundWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PlaygroundWeb.ErrorHTML, json: PlaygroundWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Playground.PubSub,
  live_view: [signing_salt: "QDbXWWoP"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :playground, Playground.Mailer, adapter: Swoosh.Adapters.Local

bun_version =
  ".tool-versions"
  |> File.stream!()
  |> Stream.filter(fn line -> String.starts_with?(line, "bun ") end)
  |> Enum.take(1)
  |> then(fn [line] -> ~r/[\d\.]+/ |> Regex.run(line) |> hd() end)

config :bun,
  version: bun_version,
  js: [
    args: ~w(
      build js/app.js
        --outdir=../priv/static/assets
        --sourcemap=external
        --external /fonts/*
        --external /images/*
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{}
  ],
  css: [
    args: ~w(
       --bun tailwindcss
        --config=tailwind.config.js
        --input=css/app.css
        --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix,
  static_compressors: [PhoenixBakery.Gzip, PhoenixBakery.Brotli]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
