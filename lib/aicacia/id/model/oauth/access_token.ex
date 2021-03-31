defmodule Aicacia.Id.Model.OAuth.AccessToken do
  use Ecto.Schema
  use ExOauth2Provider.AccessTokens.AccessToken, otp_app: :aicacia_id

  schema "oauth_access_tokens" do
    access_token_fields()

    timestamps()
  end
end
