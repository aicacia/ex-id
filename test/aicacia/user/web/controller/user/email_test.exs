defmodule Aicacia.User.Web.Controller.User.EmailTest do
  use Aicacia.User.Web.Case

  alias Aicacia.User.Service
  alias Aicacia.User.Repo
  alias Aicacia.User.Model
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

  describe "create" do
    test "should create a new email", %{conn: conn, user: user} do
      conn =
        post(
          conn,
          Routes.email_path(@endpoint, :create),
          %{
            email: "example@domain.com"
          }
        )

      email = json_response(conn, 201)

      assert email["email"] == "example@domain.com"
      assert email["user_id"] == user.id
    end

    test "should fail to create a new email if already in use", %{conn: conn, user: user} do
      Service.Email.Create.handle!(%{user_id: user.id, email: "example@domain.com"})

      conn =
        post(
          conn,
          Routes.email_path(@endpoint, :create),
          %{
            email: "example@domain.com"
          }
        )

      email = json_response(conn, 422)

      assert email["errors"]["email"] == ["has already been taken"]
    end
  end

  describe "confirm" do
    test "should confirm email", %{conn: conn, user: user} do
      email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "example@domain.com",
          primary: true
        })

      confirmation_token =
        Repo.get_by!(Model.EmailConfirmationToken, user_id: user.id, email_id: email.id)

      conn =
        put(
          conn,
          Routes.email_path(@endpoint, :confirm),
          %{
            confirmation_token: confirmation_token.confirmation_token
          }
        )

      user = json_response(conn, 200)

      assert user["email"]["confirmed"] == true
    end
  end

  describe "set primary" do
    test "should set email to primary", %{conn: conn, user: user} do
      old_email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "example1@domain.com",
          primary: true
        })

      email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "example2@domain.com"
        })

      conn =
        put(
          conn,
          Routes.email_path(@endpoint, :set_primary, email.id)
        )

      email = json_response(conn, 200)

      assert email["primary"] == true
      assert Repo.get!(Model.Email, old_email.id).primary == false
    end
  end

  describe "delete" do
    test "should delete email", %{conn: conn, user: user} do
      email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "example@domain.com"
        })

      conn =
        delete(
          conn,
          Routes.email_path(@endpoint, :delete, email.id)
        )

      json_response(conn, 200)
    end

    test "should fail to delete email if primary", %{conn: conn, user: user} do
      email =
        Service.Email.Create.handle!(%{
          user_id: user.id,
          email: "example@domain.com",
          primary: true
        })

      conn =
        delete(
          conn,
          Routes.email_path(@endpoint, :delete, email.id)
        )

      json_response(conn, 404)
    end
  end
end