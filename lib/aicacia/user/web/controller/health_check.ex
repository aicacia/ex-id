defmodule Aicacia.User.Web.Controller.HealthCheck do
  use Aicacia.User.Web, :controller

  action_fallback Aicacia.User.Web.Controller.Fallback

  def health(conn, _params) do
    conn
    |> json(%{ ok: true })
  end
end
