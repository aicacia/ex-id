use Mix.Config

config :aicacia_id,
  generators: [binary_id: true],
  ecto_repos: [Aicacia.Id.Repo]

config :aicacia_id, Aicacia.Id.Web.Endpoint,
  url: [host: "localhost"],
  check_origin: false,
  render_errors: [view: Aicacia.Id.Web.View.Error, accepts: ~w(json)],
  pubsub: [name: Aicacia.Id.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :aicacia_id, Aicacia.Id.Scheduler, debug_logging: true

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "localhost",
  app_name: "aicacia_id"

config :cors_plug,
  origin: ~r/.*/,
  methods: ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"]

config :bcrypt_elixir, log_rounds: 12

config :aicacia_id, Aicacia.Id.Web.Guardian,
  issuer: "aicacia_id",
  secret_key: System.get_env("GUARDIAN_TOKEN")

config :aicacia_id, Aicacia.Id.Repo,
  username: "postgres",
  password: "postgres",
  database: "aicacia_id_#{Mix.env()}",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true

import_config "#{Mix.env()}.exs"
