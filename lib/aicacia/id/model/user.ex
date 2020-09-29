defmodule Aicacia.Id.Model.User do
  use Ecto.Schema

  alias Aicacia.Id.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    has_one(:username, Model.Username)

    has_many(:emails, Model.Email)

    has_one(:password, Model.Password)
    has_many(:old_passwords, Model.OldPassword)

    field(:active, :boolean, null: false, default: true)

    timestamps(type: :utc_datetime)
  end
end
