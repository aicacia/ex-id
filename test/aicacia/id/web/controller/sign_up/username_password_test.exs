defmodule Aicacia.Id.Web.Controller.SignUp.UsernameAndPasswordTest do
  use Aicacia.Id.Web.Case

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "username_and_password" do
    test "should sign up with username and password", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.username_and_password_path(@endpoint, :sign_up),
          %{
            "username" => "username",
            "password" => "password"
          }
        )

      json_response(conn, 201)
    end
  end
end
