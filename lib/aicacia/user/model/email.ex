defmodule Aicacia.User.Model.Email do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "emails" do
    field(:email, :string, null: false)
    field(:confirmed, :boolean, null: false, default: false)

    timestamps(type: :utc_datetime)
  end
end
