defmodule Aicacia.Id.Web.Controller.SignUp.UsernameAndPassword do
  @moduledoc tags: ["User"]

  use Aicacia.Id.Web, :controller

  alias Aicacia.Id.Service
  use OpenApiSpex.Controller

  alias Aicacia.Id.Web.Schema

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  action_fallback Aicacia.Id.Web.Controller.Fallback

  @doc """
  Sign up

  Signs up a user and returns the User with the Bearer Token
  """
  @doc responses: [
         ok: {"Sign up User Response", "application/json", Schema.User.Private}
       ]
  def sign_up(conn, params) do
    with {:ok, command} <- Service.SignUp.UsernameAndPassword.new(params),
         {:ok, user} <- Service.SignUp.UsernameAndPassword.handle(command) do
      Aicacia.Id.Web.Controller.User.sign_in_user(conn, {:ok, user}, 201)
    end
  end
end
