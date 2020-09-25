defmodule Aicacia.Id.Web.Controller.HealthCheck do
  use Aicacia.Id.Web, :controller

  action_fallback Aicacia.Id.Web.Controller.Fallback

  def health(conn, _params) do
    conn
    |> json(%{ ok: true })
  end
end
