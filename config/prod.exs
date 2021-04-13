use Mix.Config

config :aicacia_id, Aicacia.Id.Web.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "localhost", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "aicacia-id.api"

config :aicacia_id, Aicacia.Id.Repo,
  show_sensitive_data_on_connection_error: false,
  pool_size: 30
