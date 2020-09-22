defmodule Aicacia.User.Service.SignIn.EmailPassword do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  schema "" do
    field(:email, :string)
    field(:password, :string)
  end

  def changeset(%{} = attrs) do
    %Service.SignIn.EmailPassword{}
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      email = Repo.get_by!(Model.Email, email: command.email)
      password = Repo.get_by!(Model.Password, user_id: email.user_id)

      if Bcrypt.verify_pass(command.password, password.encrypted_password) do
        Service.User.Show.handle(%{user_id: email.user_id})
      else
        {:error, %Ecto.NoResultsError{}}
      end
    end)
  end
end
