defmodule Aicacia.Id.Web.Controller.Api.User.Username do
  @moduledoc tags: ["User"]

  use Aicacia.Id.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.Controller
  alias Aicacia.Id.Web.View
  alias Aicacia.Id.Web.Schema

  action_fallback(Controller.Api.Fallback)

  @doc """
  Update User's Username

  Updates a User's Username
  """
  @doc request_body:
         {"Update User's Username Body", "application/json", Schema.User.UsernameUpdate,
          required: true},
       responses: [
         ok: {"Update User's Username Response", "application/json", Schema.User.Private}
       ]
  def update(conn, params) do
    user = conn.assigns[:user]
    user_token = conn.assigns[:user_token]

    with {:ok, command} <-
           Service.User.Update.new(%{id: user.id, username: Map.get(params, "username")}),
         {:ok, user} <- Service.User.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user, user_token: user_token)
    end
  end
end
