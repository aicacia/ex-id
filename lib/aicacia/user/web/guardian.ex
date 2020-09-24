defmodule Aicacia.User.Web.Guardian do
  use Guardian, otp_app: :aicacia_user

  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    Aicacia.User.Service.User.Show.handle(%{id: id})
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
