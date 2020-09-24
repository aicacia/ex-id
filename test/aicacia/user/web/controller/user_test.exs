defmodule Aicacia.User.Web.Controller.UserTest do
  use Aicacia.User.Web.Case

  alias Aicacia.User.Service
  alias Aicacia.User.Web.Guardian

  setup %{conn: conn} do
    user = Service.User.Create.handle!(%{})
    conn = Guardian.Plug.sign_in(conn, user)
    user_token = Guardian.Plug.current_token(conn)

    {:ok,
     user: user,
     user_token: user_token,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "current" do
    test "should return current user", %{conn: conn, user: user, user_token: user_token} do
      conn =
        get(
          conn
          |> put_req_header("authorization", user_token),
          Routes.user_path(@endpoint, :current)
        )

      user_json = json_response(conn, 200)

      assert user_json["id"] == user.id
    end

    test "should return 401 with invalid token", %{conn: conn} do
      conn =
        get(
          conn
          |> put_req_header("authorization", "invalid token"),
          Routes.user_path(@endpoint, :current)
        )

      json_response(conn, 401)
    end
  end

  describe "sign_out" do
    test "should sign out current user", %{conn: conn, user_token: user_token} do
      conn =
        delete(
          conn
          |> put_req_header("authorization", user_token),
          Routes.user_path(@endpoint, :sign_out)
        )

      json_response(conn, 204)
    end
  end
end
