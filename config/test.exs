use Mix.Config

config :aicacia_user, Aicacia.User.Web.Endpoint,
  http: [port: 4002],
  server: false

config :aicacia_user, Aicacia.User.Repo, pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn

config :bcrypt_elixir, log_rounds: 1
