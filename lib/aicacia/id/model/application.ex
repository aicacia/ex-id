defmodule Aicacia.Id.Model.Application do
  use Ecto.Schema

  alias Aicacia.Id.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "applications" do
    belongs_to(:owner, Model.User)

    field(:redirect_uri, :string, null: false)

    timestamps(type: :utc_datetime)
  end
end
