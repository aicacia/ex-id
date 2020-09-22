defmodule Aicacia.User.Service.PasswordTest do
  use Aicacia.User.Service.Case

  alias Aicacia.User.Service

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

  describe "update" do
    test "should update password" do
      user = Service.User.Create.handle!(%{})

      %{user_id: user.id, password: "password"}
      |> Service.Password.Create.new!()
      |> Service.Password.Create.handle!()

      %{user_id: user.id, password: "changed_password", old_password: "password"}
      |> Service.Password.Update.new!()
      |> Service.Password.Update.handle!()
    end
  end
end