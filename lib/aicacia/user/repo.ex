defmodule Aicacia.User.Repo do
  use Ecto.Repo,
    otp_app: :aicacia_user,
    adapter: Ecto.Adapters.Postgres
end
