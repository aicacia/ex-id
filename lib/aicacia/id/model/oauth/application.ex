defmodule Aicacia.Id.Model.OAuth.Application do
  use Ecto.Schema

  alias Aicacia.Id.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "oauth_applications" do
    belongs_to(:owner, Model.User, type: :binary_id)
    field :name, :string, null: false
    field :secret, :string, null: false
    field :redirect_uri, :string, null: false
    field :scopes, :string, default: "", null: false

    timestamps(type: :utc_datetime)
  end
end
