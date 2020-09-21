use Mix.Config

config :aicacia_user,
  generators: [binary_id: true],
  ecto_repos: [Aicacia.User.Repo]

config :aicacia_user, Aicacia.User.Web.Endpoint,
  url: [host: "localhost"],
  check_origin: false,
  render_errors: [view: Aicacia.User.Web.View.Error, accepts: ~w(json)],
  pubsub: [name: Aicacia.User.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :aicacia_user, Aicacia.User.Scheduler, debug_logging: true

config :peerage, via: Peerage.Via.Dns,
      dns_name: "localhost",
      app_name: "aicacia_user"

config :cors_plug,
  origin: ~r/.*/,
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE"]

config :aicacia_user, Aicacia.User.Repo,
  username: "postgres",
  password: "postgres",
  database: "aicacia_user_#{Mix.env()}",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true

import_config "#{Mix.env()}.exs"
