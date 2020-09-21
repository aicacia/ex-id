defmodule Aicacia.User.Web.Controller.UserTest do
  use Aicacia.User.Web.ConnCase

  alias Aicacia.User.Service

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "index" do
    test "should return empty list of users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      users_json = json_response(conn, 200)

      assert length(users_json) == 0
    end
    test "should return list of users", %{conn: conn} do
      _expected_user = create_user!()

      conn = get(conn, Routes.user_path(conn, :index))
      users_json = json_response(conn, 200)

      assert length(users_json) == 1
    end
  end

  describe "show" do
    test "should return 404", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, Ecto.UUID.generate()))
      _error = json_response(conn, 404)
    end
    test "should return a user", %{conn: conn} do
      expected_user = create_user!()

      conn = get(conn, Routes.user_path(conn, :show, expected_user.id))
      users_json = json_response(conn, 200)

      assert users_json["id"] == expected_user.id
    end
  end

  describe "create" do
    test "should create an empty user", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), %{})
      user_json = json_response(conn, 201)

      assert Map.has_key?(user_json, "id")
      assert Map.has_key?(user_json, "updated_at")
      assert Map.has_key?(user_json, "inserted_at")
    end
  end

  defp create_user!(%{} = params \\ %{}), do:
    params
    |> Service.User.Create.new!()
    |> Service.User.Create.handle!()
end
