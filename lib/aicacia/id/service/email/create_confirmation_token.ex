defmodule Aicacia.Id.Service.Email.CreateConfirmationToken do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Repo

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:email, Model.Email)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
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
          confirmation_token: :crypto.strong_rand_bytes(64) |> Base.url_encode64()
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
end
