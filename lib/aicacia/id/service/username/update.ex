defmodule Aicacia.Id.Service.Username.Update do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  schema "" do
    field(:user_id, :binary_id)
    field(:username, :string)
  end

  def changeset(%{} = attrs) do
    %Service.Username.Update{}
    |> cast(attrs, [:user_id, :username])
    |> validate_required([:user_id, :username])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get_by!(Model.Username, user_id: command.user_id)
      |> cast(
        %{username: command.username},
        [:username]
      )
      |> unique_constraint(:username)
      |> Repo.update!()
    end)
  end
end
