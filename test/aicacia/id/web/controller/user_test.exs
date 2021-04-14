defmodule Aicacia.Id.Web.Controller.UserTest do
  use Aicacia.Id.Web.Case

  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.Guardian
  alias Aicacia.Id.Web.Plug.UserAuthentication

  setup %{conn: conn} do
    user = Service.User.Create.handle!(%{username: "username"})

    {:ok,
     user: user,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "current" do
    test "should return current user", %{conn: conn, user: user} do
      conn = Guardian.Plug.sign_in(conn, user)
      user_token = Guardian.Plug.current_token(conn)

      conn =
        get(
          conn
          |> put_req_header(UserAuthentication.authorization_header(), "Bearer " <> user_token),
          Routes.api_user_path(@endpoint, :current)
        )

      user_json = json_response(conn, 200)

      assert user_json["id"] == user.id
    end

    test "should return 401 with invalid token", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.api_user_path(@endpoint, :current)
        )

      json_response(conn, 401)
    end
  end

  describe "sign_out" do
    test "should sign out current user", %{conn: conn, user: user} do
      conn = Guardian.Plug.sign_in(conn, user)
      user_token = Guardian.Plug.current_token(conn)

      conn =
        delete(
          conn
          |> put_req_header(UserAuthentication.authorization_header(), "Bearer " <> user_token),
          Routes.api_user_path(@endpoint, :sign_out)
        )

      response(conn, 204)
    end
  end
end
