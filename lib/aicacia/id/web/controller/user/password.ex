defmodule Aicacia.Id.Web.Controller.User.Password do
  @moduledoc tags: ["User"]

  use Aicacia.Id.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.Controller
  alias Aicacia.Id.Web.Schema

  action_fallback Controller.Fallback

  @doc """
  Reset Password

  Resets the User's Password creating a new Token in the process
  """
  @doc request_body:
         {"reset user password", "application/json", Schema.User.PasswordReset, required: true},
       responses: [
         ok: {"Confirmed User Email Response", "application/json", Schema.User.Private}
       ]
  def reset(conn, params) do
    user = conn.assigns[:user]

    with {:ok, command} <-
           Service.Password.Reset.new(%{
             user_id: user.id,
             old_password: Map.get(params, "old_password"),
             password: Map.get(params, "password")
           }),
         {:ok, _password} <- Service.Password.Reset.handle(command) do
      Aicacia.Id.Web.Controller.User.sign_in_user(conn, {:ok, user}, 201)
    end
  end
end
