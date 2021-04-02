defmodule Aicacia.Id.Model.OAuth.AccessToken do
  use Ecto.Schema

  alias Aicacia.Id.Model

  schema "oauth_access_tokens" do
    belongs_to :resource_owner, Model.User
    belongs_to :application, Model.OAuth.Application
    field :token, :string, null: false
    field :refresh_token, :string
    field :expires_in, :integer
    field :revoked_at, :utc_datetime
    field :scopes, :string
    field :previous_refresh_token, :string, null: false

    timestamps(type: :utc_datetime)
  end
end
