defmodule Aicacia.User.Web.Plug.UserAuthentication do
  use Aicacia.User.Web, :plug

  alias Aicacia.User.Web.Guardian
  alias Aicacia.User.Service
  alias Aicacia.User.Web.View

  def authorization_header(), do: "authorization"

  def init(opts), do: opts

  def call(conn, _opts) do
    authorize_connection(
      conn,
      get_req_header(conn, authorization_header()) |> List.first()
    )
  end

  defp authorize_connection(conn, nil), do: unauthorized(conn)

  defp authorize_connection(conn, user_token) do
    case Guardian.decode_and_verify(user_token) do
      {:ok, %{"sub" => user_id}} ->
        assign_auth_data(conn, user_token, Service.User.Show.handle(%{id: user_id}))

      _otherwise ->
        unauthorized(conn)
    end
  end

  defp assign_auth_data(conn, user_token, {:ok, user}) do
    conn
    |> assign(:user_token, user_token)
    |> assign(:user, user)
  end

  defp assign_auth_data(conn, _token, _result), do: unauthorized(conn)

  def unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(View.Error)
    |> render(:"401")
    |> halt()
  end
end