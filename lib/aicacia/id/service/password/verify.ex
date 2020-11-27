defmodule Aicacia.Id.Service.Password.Verify do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  def invalid_password_error, do: "password does not match"
  def invalid_user_id_error, do: "user_id does not exists"

  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:password, :string)
    field(:valid, :boolean, default: false)
  end

  def changeset(%{} = attrs) do
    %Service.Password.Verify{}
    |> cast(attrs, [:user_id, :password])
    |> validate_required([:user_id, :password])
    |> validate_length(:password, min: 8)
    |> foreign_key_constraint(:user_id)
    |> validate_password()
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      command.valid
    end)
  end

  defp validate_password(changeset) do
    case Repo.get_by(Model.Password, user_id: get_field(changeset, :user_id)) do
      nil ->
        add_error(changeset, :user_id, invalid_user_id_error())

      password ->
        if Bcrypt.verify_pass(get_field(changeset, :password), password.encrypted_password) do
          put_change(changeset, :valid, true)
        else
          add_error(changeset, :password, invalid_password_error())
        end
    end
  end
end
