defmodule Aicacia.Id.Service.PasswordTest do
  use Aicacia.Id.Service.Case

  alias Aicacia.Id.Service

  describe "create" do
    test "should create a password" do
      user = Service.User.Create.handle!(%{})

      password =
        %{user_id: user.id, password: "password"}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      assert password.user_id == user.id
    end

    test "should not create a password if same as current" do
      user = Service.User.Create.handle!(%{})

      %{user_id: user.id, password: "password"}
      |> Service.Password.Create.new!()
      |> Service.Password.Create.handle!()

      assert_raise(Ecto.InvalidChangesetError, fn ->
        %{user_id: user.id, password: "password"}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()
      end)
    end

    test "should not create a password if already used" do
      user = Service.User.Create.handle!(%{})

      %{user_id: user.id, password: "password"}
      |> Service.Password.Create.new!()
      |> Service.Password.Create.handle!()

      %{user_id: user.id, password: "changed_password"}
      |> Service.Password.Create.new!()
      |> Service.Password.Create.handle!()

      assert_raise(Ecto.InvalidChangesetError, fn ->
        %{user_id: user.id, password: "password"}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()
      end)
    end
  end
end
