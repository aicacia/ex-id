defmodule Aicacia.Id.Web.Controller.Api.User do
  @moduledoc tags: ["User"]

  use Aicacia.Id.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Id.Web.Guardian
  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.View
  alias Aicacia.Id.Web.Schema
  alias Aicacia.Id.Web.Plug.UserAuthentication

  action_fallback(Aicacia.Id.Web.Controller.Api.Fallback)

  @doc """
  Gets the Current User

  Returns the current user based on the bearer token
  """
  @doc responses: [
         ok: {"Current User Response", "application/json", Schema.User.Private}
       ]
  def current(conn, _params) do
    user = conn.assigns[:user]
    user_token = conn.assigns[:user_token]

    conn
    |> put_view(View.User)
    |> render("private_show.json", user: user, user_token: user_token)
  end

  @doc """
  Deactivates the Current User

  Deactivates the current User's account
  """
  @doc responses: [
         ok: {"PrivateUser", "application/json", Schema.User.Private}
       ]
  def deactivate(conn, _params) do
    user = conn.assigns[:user]
    user_token = conn.assigns[:user_token]

    with {:ok, command} <- Service.User.Deactivate.new(%{user_id: user.id}),
         {:ok, user} <- Service.User.Deactivate.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user, user_token: user_token)
    end
  end

  @doc """
  Sign current User out

  Signs out the current User based on the bearer token
  """
  @doc responses: [
         no_content: "Empty response"
       ]
  def sign_out(conn, _params) do
    user_token = UserAuthentication.get_authorization_header(conn)

    with {:ok, _claims} <- Guardian.revoke(user_token) do
      conn
      |> send_resp(204, "")
    end
  end

  def sign_in_user(conn, result, status \\ 200)

  def sign_in_user(conn, {:ok, %Model.User{} = user}, status) do
    conn = Guardian.Plug.sign_in(conn, user)
    user_token = Guardian.Plug.current_token(conn)

    conn
    |> put_resp_header(UserAuthentication.authorization_header(), user_token)
    |> put_status(status)
    |> put_view(View.User)
    |> render("private_show.json", user: user, user_token: user_token)
  end

  def sign_in_user(conn, _result, _status) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(View.Error)
    |> render(:"500")
  end
end
