defmodule Aicacia.Id.Model.OAuth.AccessGrant do
  use Ecto.Schema
  use ExOauth2Provider.AccessGrants.AccessGrant, otp_app: :aicacia_id

  schema "oauth_access_grants" do
    access_grant_fields()

    timestamps()
  end
end
