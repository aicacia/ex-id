defmodule Aicacia.User.Model.User do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    timestamps(type: :utc_datetime)
  end
end
