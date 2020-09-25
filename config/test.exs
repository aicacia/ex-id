use Mix.Config

config :aicacia_id, Aicacia.Id.Web.Endpoint,
  http: [port: 4002],
  server: false

config :aicacia_id, Aicacia.Id.Repo, pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn

config :bcrypt_elixir, log_rounds: 1
