defmodule Aicacia.Id.Web.Controller.User do
  use Aicacia.Id.Web, :controller

  alias Aicacia.Id.Web.Guardian
  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.View

  action_fallback Aicacia.Id.Web.Controller.Fallback

  def current(conn, _params) do
    user = conn.assigns[:user]
    user_token = conn.assigns[:user_token]

    conn
    |> put_view(View.User)
    |> render("private_show.json", user: user, user_token: user_token)
  end

  def deactivate(conn, _params) do
    user = conn.assigns[:user]

    with {:ok, command} <- Service.User.Deactivate.new(%{user_id: user.id}),
         {:ok, user} <- Service.User.Deactivate.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user)
    end
  end

  def sign_out(conn, _params) do
    user_token =
      conn
      |> get_req_header("authorization")
      |> List.first()

    with {:ok, _claims} <- Guardian.revoke(user_token) do
      conn
      |> put_status(204)
      |> json(%{})
    end
  end

  def sign_in_user(conn, result, status \\ 200)

  def sign_in_user(conn, {:ok, %Model.User{} = user}, status) do
    conn = Guardian.Plug.sign_in(conn, user)
    user_token = Guardian.Plug.current_token(conn)

    conn
    |> put_resp_header("authorization", user_token)
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
