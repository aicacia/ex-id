defmodule Aicacia.Id.Model.Password do
  use Ecto.Schema

  alias Aicacia.Id.Model

  schema "passwords" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:encrypted_password, :string, null: false)

    timestamps(type: :utc_datetime)
  end
end
