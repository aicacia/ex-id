defmodule Aicacia.Id.Service.Email.Delete do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:email, Model.Email)
  end

  def changeset(%{} = attrs) do
    %Service.Email.Delete{}
    |> cast(attrs, [:user_id, :email_id])
    |> validate_required([:user_id, :email_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:email_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      email =
        Repo.get_by!(Model.Email,
          id: command.email_id,
          user_id: command.user_id,
          primary: false
        )

      Repo.delete!(email)
      email
    end)
  end
end
