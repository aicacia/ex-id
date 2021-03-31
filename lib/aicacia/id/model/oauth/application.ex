defmodule Aicacia.Id.Model.OAuth.Application do
  use Ecto.Schema
  use ExOauth2Provider.Applications.Application, otp_app: :aicacia_id

  schema "oauth_applications" do
    application_fields()

    timestamps()
  end
end
