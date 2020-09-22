defmodule Aicacia.User.Service.Email.Create do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  schema "" do
    field(:user_id, :binary_id)
    field(:email, :string)
  end

  def changeset(%{} = attrs) do
    %Service.Email.Create{}
    |> cast(attrs, [:user_id, :email])
    |> validate_required([:user_id, :email])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      email =
        %Model.Email{}
        |> cast(
          %{user_id: command.user_id, email: command.email},
          [:user_id, :email]
        )
        |> foreign_key_constraint(:user_id)
        |> unique_constraint(:email)
        |> Repo.insert!()

      Service.Email.CreateConfirmationToken.handle!(%{user_id: email.user_id, email_id: email.id})

      email
    end)
  end

  def confirmation_token(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
