defmodule Aicacia.User.Service.Password.Update do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  schema "" do
    field(:user_id, :binary_id)
    field(:old_password, :string)
    field(:password, :string)
    field(:encrypted_password, :string)
  end

  def changeset(%{} = attrs) do
    %Service.Password.Update{}
    |> cast(attrs, [:user_id, :old_password, :password])
    |> validate_required([:user_id, :old_password, :password])
    |> Service.Password.Create.encrypt_password()
    |> Service.Password.Create.validate_password_not_current()
    |> Service.Password.Create.validate_password_not_already_used()
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      old_password = Repo.get_by!(Model.Password, user_id: command.user_id)

      if Bcrypt.verify_pass(command.old_password, old_password.encrypted_password) do
        Service.Password.Create.handle!(command)
      else
        {:error,
         %Service.Password.Update{}
         |> cast(%{}, [])
         |> add_error(:old_password, "old password does not match")}
      end
    end)
  end
end
