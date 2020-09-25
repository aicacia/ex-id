defmodule Aicacia.Id.Model.EmailConfirmationToken do
  use Ecto.Schema

  alias Aicacia.Id.Model

  schema "email_confirmation_tokens" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:email, Model.Email)

    field(:confirmation_token, :string, null: false)

    timestamps(type: :utc_datetime)
  end
end
