defmodule Aicacia.Id.Service.Email.CreateConfirmationToken do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:email, Model.Email)
  end

  def changeset(%{} = attrs) do
    %Service.Email.Create{}
    |> cast(attrs, [:user_id, :email_id])
    |> validate_required([:user_id, :email_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:email_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.EmailConfirmationToken{}
      |> cast(
        %{
          user_id: command.user_id,
          email_id: command.email_id,
          confirmation_token: confirmation_token(64)
        },
        [:user_id, :email_id, :confirmation_token]
      )
      |> foreign_key_constraint(:user_id)
      |> foreign_key_constraint(:email_id)
      |> unique_constraint(:email_id,
        name: :email_confirmation_token_user_id_email_id_index
      )
      |> Repo.insert!()
    end)
  end

  def confirmation_token(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
