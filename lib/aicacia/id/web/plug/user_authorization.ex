defmodule Aicacia.Id.Web.Plug.UserAuthentication do
  use Aicacia.Id.Web, :plug

  alias Aicacia.Id.Web.Guardian
  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.View

  def authorization_header(), do: "authorization"

  def get_authorization_header(conn) do
    case(get_req_header(conn, authorization_header()) |> List.first()) do
      nil -> nil
      authorization -> authorization |> String.slice(7..-1)
    end
  end

  def init(opts), do: opts

  def call(conn, _opts) do
    authorize_connection(
      conn,
      get_authorization_header(conn)
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
