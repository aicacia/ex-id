defmodule Aicacia.User.Service.Email.Confirm do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  schema "" do
    field(:confirmation_token, :string)
  end

  def changeset(%{} = attrs) do
    %Service.Email.Confirm{}
    |> cast(attrs, [:confirmation_token])
    |> validate_required([:confirmation_token])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      email_confirmation_token =
        Repo.get_by!(Model.EmailConfirmationToken, confirmation_token: command.confirmation_token)

      email =
        Repo.get_by!(Model.Email,
          id: email_confirmation_token.email_id,
          user_id: email_confirmation_token.user_id
        )
        |> cast(
          %{confirmed: true},
          [:confirmed]
        )
        |> validate_required([:confirmed])
        |> Repo.update!()

      Repo.delete!(email_confirmation_token)

      email
    end)
  end
end
