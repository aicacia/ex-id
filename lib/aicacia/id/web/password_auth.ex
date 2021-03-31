defmodule Aicacia.Id.Web.PasswordAuth do
  alias Aicacia.Id.Service

  def authenticate(username, password, otp_app: :aicacia_id) do
    case Service.SignIn.UsernameOrEmailAndPassword.new(%{username: username, password: password}) do
      {:ok, command} ->
        case Service.SignIn.UsernameOrEmailAndPassword.handle(command) do
          {:ok, user} ->
            {:ok, user}

          {:error, %Ecto.InvalidChangesetError{changeset: _changeset}} ->
            {:error, :no_user_found}
        end

      {:error, _changeset} ->
        {:error, :no_user_found}
    end
  end
end
