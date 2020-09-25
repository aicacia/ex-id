defmodule Aicacia.Id.Repo do
  use Ecto.Repo,
    otp_app: :aicacia_id,
    adapter: Ecto.Adapters.Postgres

  def run(fun_or_multi, opts \\ []) do
    try do
      Aicacia.Id.Repo.transaction(fun_or_multi, opts)
    rescue
      e -> {:error, e}
    end
  end
end
