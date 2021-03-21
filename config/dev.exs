use Mix.Config

config :aicacia_id, Aicacia.Id.Web.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :aicacia_id, Aicacia.Id.Web.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/aicacia/id/web/(live|views)/.*(ex)$",
      ~r"lib/aicacia/id/web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :bcrypt_elixir, log_rounds: 1
