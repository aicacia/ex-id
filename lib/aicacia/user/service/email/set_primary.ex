defmodule Aicacia.User.Service.Email.SetPrimary do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  schema "" do
    field(:user_id, :binary_id)
    field(:email_id, :id)
  end

  def changeset(%{} = attrs) do
    %Service.Email.Confirm{}
    |> cast(attrs, [:user_id, :email_id])
    |> validate_required([:user_id, :email_id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      user = Repo.get!(Model.User, command.user_id)

      Repo.update_all(Model.Email, set: [primary: false])

      Repo.get_by!(Model.Email, id: command.email_id, user_id: user.id)
      |> cast(
        %{primary: true},
        [:primary]
      )
      |> Repo.update!()
    end)
  end
end
