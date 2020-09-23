defmodule Aicacia.User.Web.Controller.SignIn.EmailPasswordTest do
  use Aicacia.User.Web.Case

  alias Aicacia.User.Service

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "email_password" do
    test "should sign in with email and password", %{conn: conn} do
      user = create_user!()

      conn =
        post(
          conn,
          Routes.email_password_path(@endpoint, :sign_in),
          %{
            email: "example@domain.com",
            password: "password"
          }
        )

      user_json = json_response(conn, 200)

      assert user_json["id"] == user.id
    end

    test "should fail to sign in with invalid email", %{conn: conn} do
      _user = create_user!()

      conn =
        post(
          conn,
          Routes.email_password_path(@endpoint, :sign_in),
          %{
            email: "wrong@domain.com",
            password: "password"
          }
        )

      error_json = json_response(conn, 422)

      assert error_json["errors"]["email"] == [Service.SignIn.EmailPassword.no_match_error()]
      assert error_json["errors"]["password"] == [Service.SignIn.EmailPassword.no_match_error()]
    end

    test "should fail to sign in with invalid password", %{conn: conn} do
      _user = create_user!()

      conn =
        post(
          conn,
          Routes.email_password_path(@endpoint, :sign_in),
          %{
            email: "example@domain.com",
            password: "wrong"
          }
        )

      error_json = json_response(conn, 422)

      assert error_json["errors"]["email"] == [Service.SignIn.EmailPassword.no_match_error()]
      assert error_json["errors"]["password"] == [Service.SignIn.EmailPassword.no_match_error()]
    end
  end

  defp create_user!() do
    user = Service.User.Create.handle!(%{})

    Service.Email.Create.handle!(%{user_id: user.id, email: "example@domain.com"})

    Service.Password.Create.new!(%{user_id: user.id, password: "password"})
    |> Service.Password.Create.handle!()

    Service.User.Show.handle!(%{id: user.id})
  end
end
