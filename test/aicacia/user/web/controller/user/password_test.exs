defmodule Aicacia.User.Web.Controller.User.PasswordTest do
  use Aicacia.User.Web.Case

  alias Aicacia.User.Service
  alias Aicacia.User.Web.Guardian

  setup %{conn: conn} do
    user = Service.User.Create.handle!(%{})
    conn = Guardian.Plug.sign_in(conn, user)
    user_token = Guardian.Plug.current_token(conn)

    {:ok,
     user: user,
     conn:
       conn
       |> put_req_header("authorization", user_token)
       |> put_req_header("accept", "application/json")}
  end

  describe "password reset" do
    test "should reset password", %{conn: conn, user: user} do
      _old_password =
        %{
          user_id: user.id,
          password: "old_password"
        }
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      conn =
        put(
          conn,
          Routes.password_path(@endpoint, :reset),
          %{
            old_password: "old_password",
            password: "password"
          }
        )

      json_response(conn, 201)
    end

    test "should fail to reset password if old password is invalid", %{conn: conn, user: user} do
      _old_password =
        %{
          user_id: user.id,
          password: "old_password"
        }
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      conn =
        put(
          conn,
          Routes.password_path(@endpoint, :reset),
          %{
            old_password: "invalid_old_password",
            password: "password"
          }
        )

      json_response(conn, 422)
    end
  end
end
