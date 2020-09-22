defmodule Aicacia.User.Repo do
  use Ecto.Repo,
    otp_app: :aicacia_user,
    adapter: Ecto.Adapters.Postgres

  def run(fun_or_multi, opts \\ []) do
    try do
      Aicacia.User.Repo.transaction(fun_or_multi, opts)
    rescue
      e -> {:error, e}
    end
  end

  def run!(fun_or_multi, opts \\ []) do
    case Aicacia.User.Repo.run(fun_or_multi, opts) do
      {:error, error} ->
        raise error

      result ->
        result
    end
  end
end
