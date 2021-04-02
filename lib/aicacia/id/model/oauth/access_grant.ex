defmodule Aicacia.Id.Model.OAuth.AccessGrant do
  use Ecto.Schema

  alias Aicacia.Id.Model

  schema "oauth_access_grants" do
    field(:token, :string, null: false)
    field(:expires_in, :integer, null: false)
    field(:redirect_uri, :string, null: false)
    field(:revoked_at, :utc_datetime)
    field(:scopes, :string)
    belongs_to :resource_owner, Model.User
    belongs_to :application, Model.OAuth.Application

    timestamps(type: :utc_datetime)
  end
end
