defmodule Aicacia.User.Web.Controller.User do
  use Aicacia.User.Web, :controller

  alias Aicacia.User.Web.Guardian
  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Web.View

  action_fallback Aicacia.User.Web.Controller.Fallback

  def current_user(conn, _params) do
    user = conn.assigns[:user]
    user_token = conn.assigns[:user_token]

    conn
    |> put_view(View.User)
    |> render("private_show.json", user: user, user_token: user_token)
  end

  def confirm_email(conn, params) do
    with {:ok, command} <- Service.Email.Confirm.new(params),
         {:ok, user} <- Service.Email.Confirm.handle(command) do
      sign_in_user(conn, {:ok, user})
    end
  end

  def sign_out(conn, _params) do
    user_token =
      conn
      |> get_req_header("authorization")
      |> List.first()

    with {:ok, _claims} <- Guardian.revoke(user_token) do
      send_resp(conn, :no_content, "")
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
