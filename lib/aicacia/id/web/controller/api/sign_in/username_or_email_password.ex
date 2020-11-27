defmodule Aicacia.Id.Web.Controller.Api.SignIn.UsernameOrEmailAndPassword do
  @moduledoc tags: ["User"]

  use Aicacia.Id.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.Schema

  action_fallback Aicacia.Id.Web.Controller.Api.Fallback

  @doc """
  Sign in

  Signs in user and returns the User with the Bearer Token
  """
  @doc request_body:
         {"Request body to sign in", "application/json", Schema.SignIn.UsernameOrEmailAndPassword,
          required: true},
       responses: [
         ok: {"Sign in User Response", "application/json", Schema.User.Private}
       ]
  def sign_in(conn, params) do
    with {:ok, command} <- Service.SignIn.UsernameOrEmailAndPassword.new(params),
         {:ok, user} <- Service.SignIn.UsernameOrEmailAndPassword.handle(command) do
      Aicacia.Id.Web.Controller.Api.User.sign_in_user(conn, {:ok, user})
    end
  end
end
