defmodule Aicacia.Id.Web.Controller.Api.User.UsernameTest do
  use Aicacia.Id.Web.Case

  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.Guardian
  alias Aicacia.Id.Web.Plug.UserAuthentication

  setup %{conn: conn} do
    user = Service.User.Create.handle!(%{username: "old_username"})
    conn = Guardian.Plug.sign_in(conn, user)
    user_token = Guardian.Plug.current_token(conn)

    {:ok,
     user: user,
     conn:
       conn
       |> put_req_header(UserAuthentication.authorization_header(), "Bearer " <> user_token)
       |> put_req_header("accept", "application/json")}
  end

  describe "update username" do
    test "should update user's username", %{conn: conn, user: user} do
      request_body =
        OpenApiSpex.Schema.example(Aicacia.Id.Web.Schema.User.UsernameUpdate.schema())

      conn =
        patch(
          conn,
          Routes.api_username_path(@endpoint, :update),
          request_body
        )

      assert user.username == "old_username"

      user = json_response(conn, 200)

      assert user["username"] == "username"
    end

    test "should fail to update user's username if already in use", %{conn: conn} do
      Service.User.Create.handle!(%{username: "username"})

      request_body =
        OpenApiSpex.Schema.example(Aicacia.Id.Web.Schema.User.UsernameUpdate.schema())

      conn =
        patch(
          conn,
          Routes.api_username_path(@endpoint, :update),
          request_body
        )

      user = json_response(conn, 422)

      assert user["errors"]["username"] == ["has already been taken"]
    end
  end
end
