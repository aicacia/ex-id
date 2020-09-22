defmodule Aicacia.User.Service.EmailTest do
  use Aicacia.User.Service.Case

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  describe "create" do
    test "should create an email" do
      user = Service.User.Create.handle!(%{})

      email =
        %{user_id: user.id, email: "example@domain.com"}
        |> Service.Email.Create.new!()
        |> Service.Email.Create.handle!()

      assert email.user_id == user.id

      Repo.get_by!(Model.EmailConfirmationToken, email_id: email.id, user_id: user.id)
    end

    test "should fail on non unique email" do
      user = Service.User.Create.handle!(%{})

      %{user_id: user.id, email: "example@domain.com"}
      |> Service.Email.Create.new!()
      |> Service.Email.Create.handle!()

      assert_raise(Ecto.InvalidChangesetError, fn ->
        %{user_id: user.id, email: "example@domain.com"}
        |> Service.Email.Create.new!()
        |> Service.Email.Create.handle!()
      end)
    end
  end

  describe "confirm" do
    test "should confirm an email" do
      user = Service.User.Create.handle!(%{})
      email = Service.Email.Create.handle!(%{user_id: user.id, email: "example@domain.com"})

      email_confirmation_token =
        Repo.get_by!(Model.EmailConfirmationToken, email_id: email.id, user_id: user.id)

      email =
        %{confirmation_token: email_confirmation_token.confirmation_token}
        |> Service.Email.Confirm.new!()
        |> Service.Email.Confirm.handle!()

      assert email.confirmed == true
    end
  end
end
