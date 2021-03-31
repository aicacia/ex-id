use Mix.Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    (Mix.env() == "prod" &&
       raise """
       environment variable SECRET_KEY_BASE is missing.
       You can generate one by calling: mix phx.gen.secret
       """)

database_host =
  System.get_env("DATABASE_HOST") ||
    (Mix.env() == "prod" &&
       raise """
       environment variable DATABASE_HOST is missing.
       """)

guardian_token =
  System.get_env("GUARDIAN_TOKEN") ||
    (Mix.env() == "prod" &&
       raise """
       environment variable GUARDIAN_TOKEN is missing.
       You can generate one by calling: mix guardian.gen.secret
       """)

config :aicacia_id,
  generators: [binary_id: true],
  ecto_repos: [Aicacia.Id.Repo]

config :aicacia_id, Aicacia.Id.Web.Endpoint,
  url: [host: "localhost"],
  check_origin: false,
  secret_key_base: secret_key_base,
  render_errors: [view: Aicacia.Id.Web.View.Error, accepts: ~w(html json), layout: false],
  pubsub_server: Aicacia.Id.PubSub,
  live_view: [signing_salt: "ozGtcOcL"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

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
  secret_key: guardian_token

config :aicacia_id, Aicacia.Id.Repo,
  username: "postgres",
  password: "postgres",
  database: "aicacia_id_#{Mix.env()}",
  hostname: database_host,
  show_sensitive_data_on_connection_error: true

config :aicacia_id, ExOauth2Provider,
  password_auth: {Aicacia.Id.Web.PasswordAuth, :authenticate},
  repo: Aicacia.Id.Repo,
  resource_owner: Aicacia.Id.Model.User,
  use_refresh_token: true,
  default_scopes: ~w(public),
  optional_scopes: ~w(read write)

config :aicacia_id, PhoenixOauth2Provider,
  web_module: Aicacia.Id.Web,
  current_resource_owner: :current_user

import_config "#{Mix.env()}.exs"
