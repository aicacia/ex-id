defmodule Aicacia.Id.Service.Password.Reset do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  schema "" do
    field(:user_id, :binary_id)
    field(:old_password, :string)
    field(:password, :string)
    field(:encrypted_password, :string)
  end

  def changeset(%{} = attrs) do
    %Service.Password.Reset{}
    |> cast(attrs, [:user_id, :old_password, :password])
    |> validate_required([:user_id, :old_password, :password])
    |> Service.Password.Create.encrypt_password()
    |> Service.Password.Create.validate_password_not_current()
    |> Service.Password.Create.validate_password_not_already_used()
    |> validate_old_password()
  end

  def handle(%{} = command) do
    Service.Password.Create.handle(command)
  end

  def validate_old_password(changeset) do
    case Repo.get_by!(Model.Password, user_id: get_field(changeset, :user_id)) do
      nil ->
        add_error(changeset, :old_password, "old password does not match")

      old_password ->
        case Bcrypt.verify_pass(
               get_field(changeset, :old_password, ""),
               old_password.encrypted_password
             ) do
          true ->
            changeset

          false ->
            add_error(changeset, :old_password, "old password does not match")
        end
    end
  end
end
