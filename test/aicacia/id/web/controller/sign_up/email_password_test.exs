defmodule Aicacia.Id.Web.Controller.SignUp.EmailPasswordTest do
  use Aicacia.Id.Web.Case

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "email_password" do
    test "should sign up with email and password", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.email_password_path(@endpoint, :sign_up),
          %{
            email: "example@domain.com",
            password: "password"
          }
        )

      json_response(conn, 201)
    end
  end
end
