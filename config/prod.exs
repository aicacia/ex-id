use Mix.Config

config :aicacia_user, Aicacia.User.Web.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "localhost", port: 4000]

config :logger, level: :info

config :peerage, via: Peerage.Via.Dns,
  dns_name: "user-aicacia-user.api"

config :aicacia_user, Aicacia.User.Repo,
  show_sensitive_data_on_connection_error: false,
  pool_size: 30
