defmodule Aicacia.Id.Web.Controller.HealthCheck do
  @moduledoc tags: ["Util"]

  use Aicacia.Id.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Id.Web.Schema

  action_fallback Aicacia.Id.Web.Controller.Fallback

  @doc """
  Health Check

  Returns simple json response to see if the server is up and running
  """
  @doc responses: [
         ok: {"Health Check Response", "application/json", Schema.Util.HealthCheck}
       ]
  def health(conn, _params) do
    conn
    |> json(%{ok: true})
  end
end
