defmodule Aicacia.User.Service.SignIn.EmailPassword do
  use Aicacia.Handler
  import Ecto.Changeset

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  def no_match_error, do: "email or password does not match"

  schema "" do
    field(:email, :string)
    field(:password, :string)
    field(:user_id, :binary_id)
  end

  def changeset(%{} = attrs) do
    %Service.SignIn.EmailPassword{}
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_email_password()
  end

  def handle(%{} = command) do
    Service.User.Show.handle(%{id: command.user_id})
  end

  defp validate_email_password(changeset) do
    case Repo.get_by(Model.Email, email: get_field(changeset, :email)) do
      nil ->
        changeset
        |> add_error(:email, no_match_error())
        |> add_error(:password, no_match_error())

      email ->
        case Service.Password.Verify.new(%{
               user_id: email.user_id,
               password: get_field(changeset, :password)
             }) do
          {:ok, %{valid: true}} ->
            put_change(changeset, :user_id, email.user_id)

          _error ->
            changeset
            |> add_error(:email, no_match_error())
            |> add_error(:password, no_match_error())
        end
    end
  end
end
